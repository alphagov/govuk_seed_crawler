require 'topic_exchange'

module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      urls = GetUrls.new.urls
      topic_exchange = TopicExchange.new(options)

      PublishUrls::publish(topic_exchange, options[:amqp_topic], urls)
    end
  end
end
