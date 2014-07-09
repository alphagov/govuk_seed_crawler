require 'spec_helper'

describe GovukSeedCrawler::AmqpClient do
  subject { GovukSeedCrawler::AmqpClient.new(options) }

  let(:options) { {} }

  let(:mock_bunny) do
    double(:mock_bunny, :start => true, :create_channel => true)
  end

  context "under normal usage" do
    it "responds to #channel" do
      allow(Bunny).to receive(:new).with(options).and_return(mock_bunny)
      expect(subject).to respond_to(:channel)
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
