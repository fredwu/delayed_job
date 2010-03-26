require 'spec_helper'

describe 'random ruby objects' do
  before do
    Delayed::Job.delete_all
    Delayed::Meta.delete_all
    Delayed::Worker.run_interval = 0
  end

  it "should respond_to :send_later method" do
    Object.new.respond_to?(:send_later)
  end

  it "should raise a ArgumentError if send_later is called but the target method doesn't exist" do
    lambda { Object.new.send_later(:method_that_deos_not_exist) }.should raise_error(NoMethodError)
  end

  it "should add a new entry to the job table when send_later is called on it" do
    lambda { Object.new.send_later(:to_s) }.should change { Delayed::Job.count }.by(1)
  end

  it "should add a new entry to the job table when send_later is called on the class" do
    lambda { Object.send_later(:to_s) }.should change { Delayed::Job.count }.by(1)
  end

  it "should call send later on methods which are wrapped with handle_asynchronously" do
    story = Story.create :text => 'Once upon...'
  
    Delayed::Job.count.should == 0
  
    story.whatever(1, 5)
  
    Delayed::Job.count.should == 1
    job = Delayed::Job.first
    job.payload_object.class.should   == Delayed::PerformableMethod
    job.payload_object.method.should  == :whatever_without_send_later
    job.payload_object.args.should    == [1, 5]
    job.payload_object.perform.should == 'Once upon...'
  end
  
  it "should run the first job immediately after the worker is waken up" do
    "string".send_later :count
    Delayed::Job.first.run_at.to_s.should == Time.now.to_s
  end
  
  context "last_run_at" do
    before do
      @time_now = Delayed::Job.db_time_now
      @run_interval = Delayed::Worker.run_interval = 2
      @last_run_at  = @time_now + @run_interval - 1
      Delayed::Meta.create(:last_run_at => @last_run_at)
    end
    
    it "should run at the correct time if being run before last_run_at" do
      "string".send_later :count
      Delayed::Meta.first.last_run_at.to_s.should == (@last_run_at + @run_interval).to_s
    end
    
    it "should run at the correct time if being run after last_run_at but within the run interval" do
      Time.stub!(:now).and_return(@time_now + @run_interval)
      "string".send_later :count
      Delayed::Meta.first.last_run_at.to_s.should == (@last_run_at + @run_interval).to_s
    end
    
    it "should run immediately if being run after last_run_at" do
      Time.stub!(:now).and_return(@time_now + @run_interval * 2)
      "string".send_later :count
      Delayed::Meta.first.last_run_at.to_s.should == Delayed::Job.last.run_at.to_s
    end
  end
  
  context "send_at" do
    it "should queue a new job" do
      lambda do
        "string".send_at(1.hour.from_now, :length)
      end.should change { Delayed::Job.count }.by(1)
    end
    
    it "should schedule the job in the future" do
      time = 1.hour.from_now.utc.to_time
      job = "string".send_at(time, :length)
      job.run_at.to_i.should == time.to_i
    end
    
    it "should store payload as PerformableMethod" do
      job = "string".send_at(1.hour.from_now, :count, 'r')
      job.payload_object.class.should   == Delayed::PerformableMethod
      job.payload_object.method.should  == :count
      job.payload_object.args.should    == ['r']
      job.payload_object.perform.should == 1
    end
  end

end
