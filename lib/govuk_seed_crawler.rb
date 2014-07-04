require 'govuk_seed_crawler/amqp_client'
require 'govuk_seed_crawler/cli'
require 'govuk_seed_crawler/indexer'
require 'govuk_seed_crawler/seeder'
require 'govuk_seed_crawler/url_publisher'
require 'govuk_seed_crawler/version'

module GovukSeedCrawler
  def self.logger
    @logger ||=Logger.new(STDOUT)
  end
end
