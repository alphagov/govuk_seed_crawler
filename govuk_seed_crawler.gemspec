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

  spec.required_ruby_version = "~> 2.6"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bunny", "~> 1.3"
  spec.add_runtime_dependency "crack", "0.4.5"
  spec.add_runtime_dependency "nokogiri", ">= 1.6", "< 1.14"
  # Something, somewhere, sometimes requires public_suffix.
  # public_suffix > 1.5 requires ruby > 2.
  spec.add_runtime_dependency "public_suffix", ">= 1.4.6", "< 5.1.0"
  spec.add_runtime_dependency "sitemap-parser", ">= 0.3", "< 0.6"
  spec.add_runtime_dependency "slop", "~> 3.6.0"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.13.0"
end
