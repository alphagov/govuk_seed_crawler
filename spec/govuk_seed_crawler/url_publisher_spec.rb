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

  let(:amqp_channel) { mock_amqp_channel }
  let(:exchange_name) { "publish" }
  let(:topic_name) { "#" }

  context "when calling UrlPublisher::publish_urls" do
    subject do
      url_publisher = GovukSeedCrawler::UrlPublisher.new
      url_publisher.amqp_channel = amqp_channel
      url_publisher.exchange_name = exchange_name
      url_publisher.topic_name = topic_name
      url_publisher
    end

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

    describe "when no AMQP channel is set" do
      let(:amqp_channel) { nil }

      it "raises an error" do
        expect{ subject.publish_urls(urls) }.to raise_error("AMQP channel not passed")
      end
    end

    describe "when no exchange name is set" do
      let(:exchange_name) { nil }

      it "raises an error" do
        expect{ subject.publish_urls(urls) }.to raise_error("Exchange not defined")
      end
    end

    describe "when no topic name is set" do
      let(:topic_name) { nil }

      it "raises an error" do
        expect{ subject.publish_urls(urls) }.to raise_error("Topic name not defined")
      end
    end
  end
end
