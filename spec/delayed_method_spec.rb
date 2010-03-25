require 'spec_helper'

describe 'random ruby objects' do
  before       { Delayed::Job.delete_all }

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
    job =  Delayed::Job.first
    job.payload_object.class.should   == Delayed::PerformableMethod
    job.payload_object.method.should  == :whatever_without_send_later
    job.payload_object.args.should    == [1, 5]
    job.payload_object.perform.should == 'Once upon...'
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
    
    it "should run the first job immediately after the worker is waken up" do
      "string".send_later :count
      Delayed::Job.find(:first).run_at.to_s.should == Time.now.to_s
    end
    
    it "should schedule a job based on last job's run_at time using the run_interval parameter" do
      Delayed::Worker.run_interval = 60
      
      "string".send_later :count
      "string".send_later :count
      
      Delayed::Job.count.should == 2
      
      job1 = Delayed::Job.find(:first)
      job2 = Delayed::Job.find(:last)
      
      (job2.run_at - job1.run_at).should == Delayed::Worker.run_interval
      
      Delayed::Worker.run_interval = 0
    end
  end

end
