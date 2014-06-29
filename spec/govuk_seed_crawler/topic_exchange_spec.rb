require 'spec_helper'

describe GovukSeedCrawler::TopicExchange do
  subject { GovukSeedCrawler::TopicExchange.new(options) }

  let(:options) { {} }

  let(:mock_bunny) {
    double(:mock_bunny, :start => true, :create_channel => mock_channel)
  }

  let(:mock_channel) {
    double(:mock_bunny_channel, :topic => true)
  }

  context "under normal usage" do
    it "responds to #exchange" do
      allow(Bunny).to receive(:new).with(options).and_return(mock_bunny)
      expect(subject).to respond_to(:exchange)
    end

    it "responds to #close" do
      allow(Bunny).to receive(:new).with(options).and_return(mock_bunny)
      expect(subject).to respond_to(:close)
    end

    it "creates an AMQP connection" do
      expect(Bunny).to receive(:new).with(options).and_return(mock_bunny)
      subject
    end
  end
end
