require 'sitemap-parser'

module GovukSeedCrawler
  class Indexer
    attr_reader :urls

    def initialize(site_root)
      raise "No site_root defined" unless site_root

      GovukSeedCrawler.logger.info("Retrieving list of URLs for #{site_root}")

      sitemap = SitemapParser.new("#{site_root}/sitemap.xml", {recurse: true})
      @urls = sitemap.to_a

      GovukSeedCrawler.logger.info("Found #{@urls.count} URLs")
    end
  end
end
