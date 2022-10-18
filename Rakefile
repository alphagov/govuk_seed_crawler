require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = FileList["spec/govuk_seed_crawler/**/*_spec.rb"]
end

RSpec::Core::RakeTask.new(:integration) do |task|
  task.pattern = FileList["spec/integration/**/*_spec.rb"]
end

task default: :spec
