module GovukSeedCrawler
  class UrlPublisher
    def initialize(amqp_channel, exchange_name, topic_name)
      raise "AMQP channel not passed" unless amqp_channel
      raise "Exchange not defined" unless exchange_name
      raise "Topic name not defined" unless topic_name

      @amqp_channel = amqp_channel
      @exchange_name = exchange_name
      @topic_name = topic_name
    end

    def publish_urls(urls)
      raise "No URLs defined" if urls.empty?

      urls.each do |url|
        GovukSeedCrawler.logger.debug("Publishing URL '#{url}' to topic '#{@topic_name}'")
        publish_to_exchange(url)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{@topic_name}'")
    end

    private

    def publish_to_exchange(body)
        @topic_exchange = @amqp_channel.topic(@exchange_name, :durable => true)
        @topic_exchange.publish(body, :routing_key => @topic_name)
    end
  end
end
