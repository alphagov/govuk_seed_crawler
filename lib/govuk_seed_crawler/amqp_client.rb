require 'bunny'

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
  end
end
