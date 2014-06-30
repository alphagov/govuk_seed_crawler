module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      urls = GetUrls.new(options[:site_root]).urls
      topic_connection = TopicExchange.new(options)
      topic_exchange = topic_connection.exchange

      GovukSeedCrawler.logger.info("Retrieving list of URLs for #{options[:site_root]}")
      PublishUrls::publish(topic_exchange, options[:amqp_topic], urls)

      topic_connection.close
    end
  end
end
