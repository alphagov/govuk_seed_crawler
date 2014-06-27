require 'govuk_mirrrorer/indexer'

module GovukSeedCrawler
  class GetUrls
    attr_reader @urls

    def initialize(site_root)
      raise "No :site_root defined" unless site_root

      indexer = GovukMirrorer::Indexer.new(site_root)
      @urls = indexer.all_start_urls
    end
  end
end
