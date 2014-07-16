module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      urls = Indexer.new(options[:site_root]).urls

      amqp_client = AmqpClient.new(options)

      urls.each do |url|
        amqp_client.publish(options[:exchange], options[:topic], url)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{options[:topic]}'")

      amqp_client.close
    end
  end
end
