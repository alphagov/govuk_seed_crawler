require 'spec_helper'

describe GovukSeedCrawler::UrlPublisher do
  let(:exchange) { "publish" }
  let(:topic) { "#" }

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

  subject { GovukSeedCrawler::UrlPublisher.new({}, exchange, topic) }

  before(:each) do
    allow(Bunny).to receive(:new).and_return(mock_bunny)
    allow(mock_bunny).to receive(:exchange).and_return(mock_amqp_exchange)
  end

  context "passing in params" do
    it "raises an error when no exchange name is set" do
      expect {
        GovukSeedCrawler::UrlPublisher.new({}, nil, topic)
      }.to raise_error("Exchange not defined")
    end

    it "raises an error when no topic name is set" do
      expect {
        GovukSeedCrawler::UrlPublisher.new({}, exchange, nil)
      }.to raise_error("Topic name not defined")
    end
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
