# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'govuk_seed_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "govuk_seed_crawler"
  spec.version       = GovukSeedCrawler::VERSION
  spec.authors       = ['GOV.UK developers']
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]
  spec.summary       = %q{Retrieves a list of URLs to seed the crawler by publishing them to a RabbitMQ exchange.}
  spec.homepage      = "https://github.com/alphagov/govuk_seed_crawler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bunny", "~> 1.3"
  spec.add_runtime_dependency "sitemap-parser", "~> 0.3.0"
  spec.add_runtime_dependency "slop", "~> 3.6.0"

  spec.add_development_dependency "gem_publisher", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.18.0"
end
