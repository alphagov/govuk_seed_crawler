require 'bunny'

module GovukSeedCrawler
  class TopicExchange

    attr_reader :exchange

    def initialize(exchange_name, connection_options = {})
      connect(connection_options)
      set_topic_exchange(exchange_name)
    end

    def close
      @channel.close
    end

    private

    def connect(connection_options)
      conn = Bunny.new(connection_options)
      conn.start

      @channel = conn.create_channel
    end

    def set_topic_exchange(exchange_name)
      @exchange = @channel.topic(exchange_name, :durable => true)
    end
  end
end
