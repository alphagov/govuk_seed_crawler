require "govuk_seed_crawler/amqp_client"
require "govuk_seed_crawler/cli_parser"
require "govuk_seed_crawler/cli_runner"
require "govuk_seed_crawler/indexer"
require "govuk_seed_crawler/seeder"
require "govuk_seed_crawler/version"

module GovukSeedCrawler
  class << self
    attr_writer :logger

    def logger
      unless @logger
        @logger = Logger.new($stdout)
        @logger.level = Logger::INFO
      end

      @logger
    end
  end
end
