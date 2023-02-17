# GOV.UK: Seed the Crawler

This gem retrieves a list of seed URLs from the GOV.UK sitemap and adds them to RabbitMQ
so that the [crawler](https://github.com/alphagov/govuk_crawler_worker) can consume them.

## Installation

Add this line to your application's Gemfile:

    gem 'govuk_seed_crawler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install govuk_seed_crawler

## Usage

To run with the RabbitMQ connection defaults:

```bash
bundle exec seed-crawler https://www.gov.uk/
```

Run with `--help` to see a list of options:

```bash
bundle exec seed-crawler --help
```

## Deployment

The gem is automatically deployed to RubyGems when the gem [version](https://github.com/alphagov/govuk_seed_crawler/blob/main/lib/govuk_seed_crawler/version.rb) is updated on `main`. (Don't forget to add to the [CHANGELOG](https://github.com/alphagov/govuk_seed_crawler/blob/main/CHANGELOG.md)!

For the new gem version to be used on GOV.UK, you'll need to update the [reference in govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/c5112961e9c3063f077d2de2ffa887b00466c623/modules/govuk_crawler/manifests/init.pp#L142-L150).

## Contributing

1. Fork it ( http://github.com/{my-github-username}/govuk_seed_crawler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licence

[MIT License](LICENCE)
