require 'spec_helper'

describe GovukSeedCrawler::Seeder do
  subject { GovukSeedCrawler::Seeder::seed(options) }

  let(:mock_publish_urls) do
    double(:mock_publish_urls, :publish => true)
  end

  let(:mock_topic_exchange) do
    double(:mock_topic_exchange, :exchange => mock_topic_exchange_obj, :close => true)
  end

  let(:mock_topic_exchange_obj) do
    double(:mock_topic_exchange_obj, :publish => true)
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
      allow(GovukSeedCrawler::GetUrls).to receive(:urls).and_return(urls)
      allow(GovukSeedCrawler::TopicExchange).to receive(:new).and_return(mock_topic_exchange)
      allow(mock_topic_exchange).to receive(:exchange).and_return(mock_topic_exchange_obj)

      expect(GovukSeedCrawler::PublishUrls).to receive(:publish).with(mock_topic_exchange_obj, options[:amqp_topic], urls)
      subject
    end

    it "closes the connection when done" do
      allow(GovukSeedCrawler::GetUrls).to receive(:urls).and_return(urls)
      allow(GovukSeedCrawler::TopicExchange).to receive(:new).and_return(mock_topic_exchange)

      expect(mock_topic_exchange).to receive(:close)
      subject
    end
  end
end
