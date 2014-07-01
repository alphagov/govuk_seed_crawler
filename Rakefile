require 'bundler/gem_tasks'
require 'gem_publisher'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = FileList['spec/govuk_seed_crawler/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:integration) do |task|
  task.pattern = FileList['spec/integration/**/*_spec.rb']
end

task :default => :spec

desc "Publish gem to GemFury"
task :publish_gem do |t|
  gem = GemPublisher.publish_if_updated("govuk_seed_crawler.gemspec", :gemfury, :as => "govuk")
  puts "Published #{gem}" if gem
end
