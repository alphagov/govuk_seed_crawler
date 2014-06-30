module GovukSeedCrawler
  class PublishUrls
    def self.publish(topic_exchange, topic_name, urls)
      raise "Exchange not defined" unless topic_exchange
      raise "No URLs defined" if urls.empty?

      urls.each do |url|
        url = url.strip
        topic_exchange.publish(url, :routing_key => topic_name)
        GovukSeedCrawler.logger.debug("Publishing URL '#{url}' to topic '#{topic_name}'")
      end
    end
  end
end
