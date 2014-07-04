require 'spec_helper'

describe GovukSeedCrawler::Seeder do
  subject { GovukSeedCrawler::Seeder::seed({}) }

  let(:mock_get_urls) do
    double(:mock_get_urls, :urls => true)
  end

  let(:mock_amqp_client) do
    double(:mock_amqp_client, :channel => mock_amqp_channel, :close => true)
  end

  let(:mock_amqp_channel) do
    double(:mock_amqp_channel, :topic => true)
  end

  let(:mock_amqp_exchange) do
    double(:mock_amqp_exchange, :publish => true)
  end

  let(:mock_url_publisher) do
    double(:mock_url_publisher,
      :amqp_channel => true,
      :exchange_name => true,
      :publish_urls => true,
      :topic_name => true,
    )
  end

  let(:urls) do
    [
      "https://example.com/foo",
      "https://example.com/bar",
      "https://example.com/baz",
    ]
  end

  before(:each) do
      allow(GovukSeedCrawler::GetUrls).to receive(:new).and_return(mock_get_urls)
      allow(mock_get_urls).to receive(:urls).and_return(urls)

      allow(GovukSeedCrawler::AmqpClient).to receive(:new).and_return(mock_amqp_client)
      allow(mock_amqp_client).to receive(:exchange).and_return(mock_amqp_exchange)

      allow(GovukSeedCrawler::UrlPublisher).to receive(:new).and_return(mock_url_publisher)
      allow(mock_url_publisher).to receive(:amqp_channel=).and_return(mock_amqp_channel)
      allow(mock_url_publisher).to receive(:exchange_name=).and_return("topic-name")
      allow(mock_url_publisher).to receive(:topic_name=).and_return("#")
  end

  context "under normal usage" do
    it "calls GovukSeedCrawler::UrlPublisher#publish with the correct arguments" do
      expect(mock_url_publisher).to receive(:publish_urls).with(urls)
      subject
    end

    it "closes the connection when done" do
      allow(mock_url_publisher).to receive(:publish_urls).with(urls)
      expect(mock_amqp_client).to receive(:close)
      subject
    end
  end
end
