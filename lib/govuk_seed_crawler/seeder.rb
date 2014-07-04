module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      amqp_connection_options = options.reject do |key, _value|
        %w{:amqp_host :amqp_port :amqp_username :amqp_password}.include?(key) == false
      end

      amqp_client = AmqpClient.new(amqp_connection_options)
      amqp_channel = amqp_client.channel

      urls = GetUrls.new(options[:site_root]).urls

      url_publisher = UrlPublisher.new(amqp_channel, options[:amqp_exchange], options[:amqp_topic])
      url_publisher.publish_urls(urls)

      amqp_client.close
    end
  end
end
