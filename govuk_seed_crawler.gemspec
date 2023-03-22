lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "govuk_seed_crawler/version"

Gem::Specification.new do |spec|
  spec.name          = "govuk_seed_crawler"
  spec.version       = GovukSeedCrawler::VERSION
  spec.authors       = ["GOV.UK developers"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]
  spec.summary       = "Retrieves a list of URLs to seed the crawler by publishing them to a RabbitMQ exchange."
  spec.homepage      = "https://github.com/alphagov/govuk_seed_crawler"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency "bunny", ">= 1.3", "< 3.0"
  spec.add_runtime_dependency "crack", "0.4.5"
  spec.add_runtime_dependency "nokogiri", ">= 1.6", "< 1.15"
  # Something, somewhere, sometimes requires public_suffix.
  # public_suffix > 1.5 requires ruby > 2.
  spec.add_runtime_dependency "public_suffix", ">= 1.4.6", "< 5.1.0"
  spec.add_runtime_dependency "sitemap-parser", ">= 0.3", "< 0.6"
  spec.add_runtime_dependency "slop", ">= 4.0", "< 4.11"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.0"
  spec.add_development_dependency "rubocop-govuk", "4.10.0"
  spec.add_development_dependency "webmock", "~> 3.18"
end
