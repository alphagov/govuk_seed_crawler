require "spec_helper"

describe GovukSeedCrawler::Seeder do
  let(:exchange) { "seeder_test_exchange" }
  let(:topic) { "#" }
  let(:root_url) { "https://www.example.com" }

  let(:options) do
    {
      exchange: exchange,
      topic: topic,
    }
  end

  let(:mock_get_urls) { double(:mock_get_urls, urls: true) }
  let(:mock_amqp_client) { double(:mock_amqp_client, close: true) }

  let(:urls) do
    [
      "https://example.com/foo",
      "https://example.com/bar",
      "https://example.com/baz",
    ]
  end

  before do
    allow(GovukSeedCrawler::Indexer).to receive(:new)
      .with(root_url)
      .and_return(mock_get_urls)
    allow(mock_get_urls).to receive(:urls).and_return(urls)
    allow(GovukSeedCrawler::AmqpClient).to receive(:new)
      .with(options).and_return(mock_amqp_client)
  end

  it "publishes urls to the queue" do
    urls.each do |url|
      expect(mock_amqp_client).to receive(:publish)
        .with(exchange, topic, url)
    end

    described_class.seed(root_url, options)
  end

  it "closes the connection when done" do
    allow(mock_amqp_client).to receive(:publish)
    expect(mock_amqp_client).to receive(:close)
    described_class.seed(root_url, options)
  end
end
