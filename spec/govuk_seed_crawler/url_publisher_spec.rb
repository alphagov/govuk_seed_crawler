require 'spec_helper'

describe GovukSeedCrawler::UrlPublisher do
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

  context "when instantiated" do
    describe "with incorrect arguments" do
      subject { GovukSeedCrawler::UrlPublisher }

      it "raises an error no AMQP channel is passed in" do
        expect{ subject.new(nil, "publish", "#") }.to raise_error("AMQP channel not passed")
      end

      it "raises an error no exchange name is passed in" do
        expect{ subject.new(mock_amqp_channel, nil, "#") }.to raise_error("Exchange not defined")
      end

      it "raises an error no topic name is passed in" do
        expect{ subject.new(mock_amqp_channel, "publish", nil) }.to raise_error("Topic name not defined")
      end
    end
  end

  context "when calling UrlPublisher::publish_urls" do
    subject { GovukSeedCrawler::UrlPublisher.new(mock_amqp_channel, "publish", "#") }

    it "publishes to the topic exchange with the correct arguments" do
      expect(mock_topic_exchange).to receive(:publish).with(urls.first, { :routing_key => "#" })
      subject.publish_urls(urls)
    end

    it "publishes each of the URLs passed in once only" do
      expect(mock_topic_exchange).to receive(:publish).exactly(urls.count).times
      subject.publish_urls(urls)
    end

    it "raises an error no URLs are passed in" do
      expect{ subject.publish_urls({}) }.to raise_error("No URLs defined")
    end
  end
end
