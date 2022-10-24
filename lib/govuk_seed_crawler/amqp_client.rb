require "bunny"

module GovukSeedCrawler
  class AmqpClient
    attr_reader :channel

    def initialize(connection_options = {})
      @conn = Bunny.new(connection_options)
      @conn.start
      @channel = @conn.create_channel
    end

    def close
      @conn.close
    end

    def publish(exchange, topic, body)
      raise "Exchange cannot be nil" if exchange.nil?
      raise "Topic cannot be nil" if topic.nil?
      raise "Message body cannot be nil" if body.nil?

      GovukSeedCrawler.logger.debug("Publishing '#{body}' to topic '#{topic}'")

      @channel.topic(exchange, durable: true)
        .publish(body, routing_key: topic)
    end
  end
end
