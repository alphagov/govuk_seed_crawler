module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      amqp_connection_options = options.reject do |key, _value|
        %w{:amqp_host :amqp_port :amqp_username :amqp_password}.include?(key)
      end

      topic_connection = TopicExchange.new(options[:amqp_exchange], amqp_connection_options)
      topic_exchange = topic_connection.exchange

      urls = GetUrls.new(options[:site_root]).urls

      PublishUrls::publish(topic_exchange, options[:amqp_topic], urls)

      topic_connection.close
    end
  end
end
