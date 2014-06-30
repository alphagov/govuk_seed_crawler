require 'govuk_mirrorer/indexer'
require 'govuk_mirrorer/statsd'

module GovukSeedCrawler
  class GetUrls
    def self.urls(site_root)
      raise "No site_root defined" unless site_root

      GovukSeedCrawler.logger.info("Retrieving list of URLs for #{site_root}")
      indexer = GovukMirrorer::Indexer.new(site_root)
      urls = indexer.all_start_urls

      GovukSeedCrawler.logger.info("Found #{urls.count} URLs")

      urls
    end
  end
end
