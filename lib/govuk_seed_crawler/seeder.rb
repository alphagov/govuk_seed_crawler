module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      amqp_connect_options = self.extract_amqp_connect_options(options)

      urls = Indexer.new(options[:site_root]).urls

      url_publisher = UrlPublisher.new(amqp_connect_options)
      url_publisher.exchange_name = options[:amqp_exchange]
      url_publisher.topic_name = options[:amqp_topic]
      url_publisher.publish_urls(urls)
      url_publisher.close
    end

    def self.extract_amqp_connect_options(options)
      amqp_connect_options = options.reject do |key, _value|
        %w{:amqp_host :amqp_port :amqp_username :amqp_password}.include?(key) == false
      end
    end
  end
end
