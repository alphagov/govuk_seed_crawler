require 'spec_helper'

describe GovukSeedCrawler::Seeder do
  subject { GovukSeedCrawler::Seeder }

  let(:mock_get_urls) do
    double(:mock_get_urls, :urls => true)
  end

  let(:mock_publish_urls) do
    double(:mock_publish_urls, :publish => true)
  end

  let(:mock_topic_exchange) do
    double(:mock_topic_exchange, :publish => true)
  end


  let(:urls) do
    [
      "https://example.com/foo",
      "https://example.com/bar",
      "https://example.com/baz",
    ]
  end

  let (:options) do
    {
      :amqp_topic => "#"
    }
  end

  context "under normal usage" do
    it "calls GovukSeedCrawler::PublishUrls::publish with the correct arguments" do
      allow(GovukSeedCrawler::GetUrls).to receive(:new).and_return(mock_get_urls)
      allow(mock_get_urls).to receive(:urls).and_return(urls)
      allow(GovukSeedCrawler::TopicExchange).to receive(:new).and_return(mock_topic_exchange)

      expect(GovukSeedCrawler::PublishUrls).to receive(:publish).with(mock_topic_exchange, options[:amqp_topic], urls)
      subject::seed(options)
    end
  end
end
