module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      urls = Indexer.new(options[:site_root]).urls

      url_publisher = UrlPublisher.new(
        options, options[:amqp_exchange], options[:amqp_topic])
      url_publisher.publish_urls(urls)
      url_publisher.close
    end
  end
end
