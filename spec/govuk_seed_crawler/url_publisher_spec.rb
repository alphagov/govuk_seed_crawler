require 'spec_helper'

describe GovukSeedCrawler::UrlPublisher do
  let(:mock_amqp_channel) do
    double(:mock_amqp_channel, :topic => mock_amqp_exchange)
  end

  let(:mock_bunny) do
    double(:mock_bunny, :start => true, :create_channel => mock_amqp_channel, :close => true)
  end

  let(:mock_amqp_exchange) do
    double(:mock_amqp_exchange, :publish => true)
  end

  let(:urls) do
    [
      "https://example.com/foo",
      "https://example.com/bar",
      "https://example.com/baz",
    ]
  end

  let(:exchange_name) { "publish" }
  let(:topic_name) { "#" }

  subject do
    url_publisher = GovukSeedCrawler::UrlPublisher.new({})
    url_publisher.exchange_name = exchange_name
    url_publisher.topic_name = topic_name
    url_publisher
  end

  before(:each) do
    allow(Bunny).to receive(:new).and_return(mock_bunny)
    allow(mock_bunny).to receive(:exchange).and_return(mock_amqp_exchange)
  end

  context "when calling UrlPublisher::publish_urls" do
    it "publishes to the topic exchange with the correct arguments" do
      expect(mock_amqp_exchange).to receive(:publish).with(urls.first, { :routing_key => "#" })
      subject.publish_urls(urls)
    end

    it "publishes each of the URLs passed in once only" do
      expect(mock_amqp_exchange).to receive(:publish).exactly(urls.count).times
      subject.publish_urls(urls)
    end

    it "raises an error no URLs are passed in" do
      expect{ subject.publish_urls({}) }.to raise_error("No URLs defined")
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

  context "before exiting" do
    it "responds to #close" do
      expect(subject).to respond_to(:close)
    end

    it "closes the AMQP client connection when asked to close" do
      expect(mock_bunny).to respond_to(:close)
      subject.publish_urls(urls)
    end
  end
end
