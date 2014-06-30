require 'bunny'

module GovukSeedCrawler
  class AmqpClient

    attr_reader :channel

    def initialize(connection_options = {})
      connect(connection_options)
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
  end
end
