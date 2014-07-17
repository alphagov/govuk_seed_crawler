module GovukSeedCrawler
  class Seeder
    def self.seed(site_root, options = {})
      amqp_client = AmqpClient.new(options)
      urls = Indexer.new(site_root).urls

      urls.each do |url|
        amqp_client.publish(options[:exchange], options[:topic], url)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{options[:topic]}'")

      amqp_client.close
    end
  end
end
