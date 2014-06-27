require 'bunny'

module GovukSeedCrawler
  class TopicExchange

    attr_reader :exchange

    def initialize(options = {})
      connect(options)
      connect_to_topic_exchange(options[:amqp_exchange])
    end

    def close
      @channel.close
    end

    private

    def connect(options)
      conn = Bunny.new(options)
      conn.start

      @channel = conn.create_channel
    end

    def connect_to_topic_exchange(exchange_name)
      @exchange = channel.topic(exchange_name, :durable => true)
    end
  end
end
