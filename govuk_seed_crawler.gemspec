# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'govuk_seed_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "govuk_seed_crawler"
  spec.version       = GovukSeedCrawler::VERSION
  spec.authors       = ["Matt Bostock"]
  spec.email         = ["matt.bostock@digital.cabinet-office.gov.uk"]
  spec.summary       = %q{Retrieves a list of URLs to seed the crawler by publishing them to a RabbitMQ exchange.}
  spec.homepage      = "https://github.gds/gds/govuk_seed_crawler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "govuk_mirrorer", "~> 1.3.1"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "gemfury", "~> 0.4.23"
  spec.add_development_dependency "gem_publisher", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
end
