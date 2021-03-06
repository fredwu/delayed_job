# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{delayed_job}
  s.version = "1.8.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brandon Keepers", "Tobias L\303\274tke"]
  s.date = %q{2010-03-25}
  s.description = %q{Delayed_job (or DJ) encapsulates the common pattern of asynchronously executing longer tasks in the background. It is a direct extraction from Shopify where the job table is responsible for a multitude of core tasks.}
  s.email = %q{tobi@leetsoft.com}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "contrib/delayed_job.monitrc",
     "delayed_job.gemspec",
     "generators/delayed_job/delayed_job_generator.rb",
     "generators/delayed_job/templates/migration.rb",
     "generators/delayed_job/templates/script",
     "init.rb",
     "lib/delayed/backend/active_record.rb",
     "lib/delayed/backend/base.rb",
     "lib/delayed/backend/mongo_mapper.rb",
     "lib/delayed/command.rb",
     "lib/delayed/message_sending.rb",
     "lib/delayed/performable_method.rb",
     "lib/delayed/recipes.rb",
     "lib/delayed/tasks.rb",
     "lib/delayed/worker.rb",
     "lib/delayed_job.rb",
     "moneypools-delayed_job.gemspec",
     "recipes/delayed_job.rb",
     "spec/backend/active_record_job_spec.rb",
     "spec/backend/mongo_mapper_job_spec.rb",
     "spec/backend/shared_backend_spec.rb",
     "spec/delayed_method_spec.rb",
     "spec/performable_method_spec.rb",
     "spec/sample_jobs.rb",
     "spec/setup/active_record.rb",
     "spec/setup/mongo_mapper.rb",
     "spec/spec_helper.rb",
     "spec/story_spec.rb",
     "spec/worker_spec.rb",
     "tasks/jobs.rake"
  ]
  s.homepage = %q{http://github.com/collectiveidea/delayed_job}
  s.rdoc_options = ["--main", "README.textile", "--inline-source", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Database-backed asynchronous priority queue system -- Extracted from Shopify}
  s.test_files = [
    "spec/backend",
     "spec/backend/active_record_job_spec.rb",
     "spec/backend/mongo_mapper_job_spec.rb",
     "spec/backend/shared_backend_spec.rb",
     "spec/delayed_method_spec.rb",
     "spec/performable_method_spec.rb",
     "spec/sample_jobs.rb",
     "spec/setup",
     "spec/setup/active_record.rb",
     "spec/setup/mongo_mapper.rb",
     "spec/spec_helper.rb",
     "spec/story_spec.rb",
     "spec/worker_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<daemons>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
    else
      s.add_dependency(%q<daemons>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<daemons>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
  end
end

