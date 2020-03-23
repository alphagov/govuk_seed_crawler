module GovukSeedCrawler
  class Seeder
    def self.seed(site_root, options = {})
      amqp_client = AmqpClient.new(options)

      if options[:only_this_page]
        urls = [site_root]
      else
        urls = Indexer.new(site_root).urls
      end

      urls.each do |url|
        amqp_client.publish(options[:exchange], options[:topic], url)
      end

      GovukSeedCrawler.logger.info("Published #{urls.count} URLs to topic '#{options[:topic]}'")

      amqp_client.close
    end
  end
end
