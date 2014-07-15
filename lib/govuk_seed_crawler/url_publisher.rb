module GovukSeedCrawler
  class UrlPublisher
    def initialize(options, exchange, topic)
      raise "Exchange not defined" if exchange.nil?
      raise "Topic name not defined" if topic.nil?

      @amqp_client = AmqpClient.new(options)
      @amqp_channel = @amqp_client.channel
      @exchange = exchange
      @topic = topic
    end

    def publish_urls(urls)
      raise "AMQP channel not passed" unless @amqp_channel
      raise "No URLs defined" if urls.empty?

      urls.each do |url|
        GovukSeedCrawler.logger.debug("Publishing URL '#{url}' to topic '#{@topic}'")
        publish_to_exchange(url)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{@topic}'")
    end

    def close
      @amqp_client.close
    end

    private

    def publish_to_exchange(body)
      @amqp_channel.topic(@exchange, :durable => true)
        .publish(body, :routing_key => @topic)
    end
  end
end
