module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      urls = GetUrls.new.urls(options[:site_root])
      topic_exchange = TopicExchange.new(options)

      PublishUrls::publish(topic_exchange, options[:amqp_topic], urls)
    end
  end
end
