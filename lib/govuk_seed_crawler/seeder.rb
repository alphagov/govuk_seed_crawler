module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      amqp_connection_options = options.reject do |key, _value|
        %w{:amqp_host :amqp_port :amqp_username :amqp_password}.include?(key) == false
      end

      urls = GetUrls.new(options[:site_root]).urls

      url_publisher = UrlPublisher.new(amqp_connection_options)

      url_publisher.exchange_name = options[:amqp_exchange]
      url_publisher.topic_name = options[:amqp_topic]
      url_publisher.publish_urls(urls)
      url_publisher.close
    end
  end
end
