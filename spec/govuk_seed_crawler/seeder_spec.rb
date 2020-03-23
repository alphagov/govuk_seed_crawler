require 'spec_helper'

describe GovukSeedCrawler::Seeder do
  let(:exchange) { "seeder_test_exchange" }
  let(:topic) { "#" }
  let(:root_url) { "https://www.example.com" }

  let(:options) {{
    :exchange => exchange,
    :topic => topic,
  }}

  let(:mock_get_urls) { double(:mock_get_urls, :urls => true) }
  let(:mock_amqp_client) { double(:mock_amqp_client, :close => true) }

  let(:urls) do
    [
     "https://example.com/foo",
     "https://example.com/bar",
     "https://example.com/baz",
    ]
  end

  subject { GovukSeedCrawler::Seeder::seed(root_url, options) }

  describe ":only_this_page = true" do
    let(:options) {{
      :exchange => exchange,
      :topic => topic,
      :only_this_page => true
    }}

    before(:each) do
      allow(GovukSeedCrawler::AmqpClient).to receive(:new)
        .with(options).and_return(mock_amqp_client)
    end

    it "only seeds the root URL" do
        expect(mock_amqp_client).to receive(:publish).with(exchange, topic, root_url)
        subject
    end
  end

  describe ":only_this_page = false" do
    before(:each) do
      allow(GovukSeedCrawler::Indexer).to receive(:new)
        .with(root_url)
        .and_return(mock_get_urls)
      allow(mock_get_urls).to receive(:urls).and_return(urls)
      allow(GovukSeedCrawler::AmqpClient).to receive(:new)
        .with(options).and_return(mock_amqp_client)
    end

    context "under normal usage" do
      it "publishes urls to the queue" do
        urls.each do |url|
          expect(mock_amqp_client).to receive(:publish)
            .with(exchange, topic, url)
        end

        subject
      end

      it "closes the connection when done" do
        allow(mock_amqp_client).to receive(:publish)
        expect(mock_amqp_client).to receive(:close)
        subject
      end
    end
  end
end
