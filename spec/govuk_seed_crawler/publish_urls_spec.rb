require 'spec_helper'

describe GovukSeedCrawler::PublishUrls do
  subject { GovukSeedCrawler::PublishUrls }

  let(:mock_amqp_channel) do
    double(:mock_amqp_channel, :topic => mock_topic_exchange)
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

  context "under normal usage" do
    it "calls #publish with the correct arguments" do
      expect(mock_topic_exchange).to receive(:publish).with(urls.first, { :routing_key => "#" })
      subject::publish(mock_amqp_channel, "publish", "#", urls)
    end

    it "publishes each of the URLs passed in once only" do
      expect(mock_topic_exchange).to receive(:publish).exactly(urls.count).times
      subject::publish(mock_amqp_channel, "publish", "#", urls)
    end
  end

  context "under incorrect usage" do
    it "raises an error no AMQP channel is passed in" do
      expect{ subject::publish(nil, "exchange-name", "topic-name", urls) }.to raise_error("AMQP channel not passed")
    end

    it "raises an error no exchange name is passed in" do
      expect{ subject::publish(mock_amqp_channel, nil, "topic-name", urls) }.to raise_error("Exchange not defined")
    end

    it "raises an error no topic name is passed in" do
      expect{ subject::publish(mock_amqp_channel, "exchange-name", nil, urls) }.to raise_error("Topic name not defined")
    end

    it "raises an error no URLs are passed in" do
      expect{ subject::publish(mock_amqp_channel, "exchange-name", "topic-name", {}) }.to raise_error("No URLs defined")
    end
  end
end
