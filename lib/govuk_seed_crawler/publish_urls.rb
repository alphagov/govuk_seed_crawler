module GovukSeedCrawler
  class PublishUrls
    def self.publish(topic_exchange, topic_name, urls)
      raise "Exchange not defined" unless topic_exchange
      raise "No URLs defined" if urls.empty?

      urls.each do |url|
        GovukSeedCrawler.logger.debug("Publishing URL '#{url}' to topic '#{topic_name}'")

        url = url.strip
        topic_exchange.publish(url, :routing_key => topic_name)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{topic_name}'")
    end
  end
end
