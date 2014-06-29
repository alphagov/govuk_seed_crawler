require 'spec_helper'

describe GovukSeedCrawler::PublishUrls do
  subject { GovukSeedCrawler::PublishUrls }

  let(:mock_topic_exchange) do
    double(:mock_topic_exchange, :publish => true)
  end

  context "under normal usage" do
    let(:urls) do
      [
        "https://example.com/foo",
        "https://example.com/bar",
        "https://example.com/baz",
      ]
    end

    it "calls #publish with the correct arguments" do
      expect(mock_topic_exchange).to receive(:publish).with(urls.first, { :routing_key => "#" })
      subject::publish(mock_topic_exchange, "#", urls)
    end

    it "publishes each of the URLs passed in once only" do
      expect(mock_topic_exchange).to receive(:publish).exactly(urls.count).times
      subject::publish(mock_topic_exchange, "#", urls)
    end
  end

  context "under incorrect usage" do
    it "raises an error no topic exchange is passed in" do
      expect{ subject::publish(nil, "topic-name", {}) }.to raise_error("Exchange not defined")
    end

    it "raises an error no URLs are passed in" do
      expect{ subject::publish(mock_topic_exchange, "topic-name", {}) }.to raise_error("No URLs defined")
    end
  end
end
