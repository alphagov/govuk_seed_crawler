module GovukSeedCrawler
  class UrlPublisher
    attr_writer :exchange_name, :topic_name

    def initialize(amqp_connect_options)
      @amqp_client = AmqpClient.new(amqp_connect_options)
      @amqp_channel = @amqp_client.channel
    end

    def publish_urls(urls)
      raise "AMQP channel not passed" unless @amqp_channel
      raise "Exchange not defined" unless @exchange_name
      raise "Topic name not defined" unless @topic_name
      raise "No URLs defined" if urls.empty?

      urls.each do |url|
        GovukSeedCrawler.logger.debug("Publishing URL '#{url}' to topic '#{@topic_name}'")
        publish_to_exchange(url)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{@topic_name}'")
    end

    def close
      @amqp_client.close
    end

    private

    def publish_to_exchange(body)
        @topic_exchange = @amqp_channel.topic(@exchange_name, :durable => true)
        @topic_exchange.publish(body, :routing_key => @topic_name)
    end
  end
end
