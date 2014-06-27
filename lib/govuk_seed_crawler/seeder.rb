module GovukSeedCrawler
  class Seeder
    def self.seed(options = {})
      urls = GetUrls.new.urls
      raise "No URLs were found" if urls.empty?

      messenger = Messaging.new(options)
      PublishUrls::publish(messenger, urls)
    end
  end
end
