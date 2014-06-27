module GovukSeedCrawler
  class PublishUrls
    def self.publish(messenger, urls)
      urls.each do |url|
        messenger.publish_url(url)
      end
    end
  end
end
