module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      urls = Indexer.new(options[:site_root]).urls

      amqp_client = AmqpClient.new(options)

      urls.each do |url|
        amqp_client.publish(options[:amqp_exchange], options[:amqp_topic], url)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{options[:amqp_topic]}'")

      amqp_client.close
    end
  end
end
