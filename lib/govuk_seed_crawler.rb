require 'govuk_seed_crawler/cli'
require 'govuk_seed_crawler/get_urls'
require 'govuk_seed_crawler/publish_urls'
require 'govuk_seed_crawler/seeder'
require 'govuk_seed_crawler/topic_exchange'
require 'govuk_seed_crawler/version'

module GovukSeedCrawler
  def self.logger
    @logger ||=Logger.new(STDOUT)
  end
end
