require 'bunny'

module GovukSeedCrawler
  class Messaging
    def connect(options = {})
      conn = Bunny.new(options)
      conn.start

      @channel = conn.create_channel
    end

    def connect_to_topc
      @exchange = channel.topic(@exchange, :durable => true)
    end

    def publish_url(url)
      unless @exchange raise "Exchange not defined"
      unless @topic raise "Topic not defined"
      unless url raise "URL not defined"

      url = url.strip
      @exchange.publish(url, :routing_key => @topic)
      # log something
    end

    def disconnect
      @channel.close
    end
  end
end
