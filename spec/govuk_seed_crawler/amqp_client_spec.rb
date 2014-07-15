require 'spec_helper'

describe GovukSeedCrawler::AmqpClient do
  subject { GovukSeedCrawler::AmqpClient.new }

  it "responds to #channel" do
    expect(subject).to respond_to(:channel)
  end

  it "responds to #close" do
    expect(subject).to respond_to(:close)
  end

  it "closes the connection to the AMQP server" do
    mock_bunny = double(:mock_bunny,
      :start => true, :create_channel => true, :close => true)
    allow(Bunny).to receive(:new).and_return(mock_bunny)
    expect(mock_bunny).to receive(:close).once

    subject.close
  end

  context "#publish" do
    context "error handling" do
      it "raises an exception if exchange is nil" do
        expect {
          subject.publish(nil, "#", "some body")
        }.to raise_exception(RuntimeError, "Exchange cannot be nil")
      end

      it "raises an exception if topic is nil" do
        expect {
          subject.publish("amqp_client_test_exchange", nil, "some body")
        }.to raise_exception(RuntimeError, "Topic cannot be nil")
      end

      it "raises an exception if body is nil" do
        expect {
          subject.publish("amqp_client_test_exchange", "#", nil)
        }.to raise_exception(RuntimeError, "Message body cannot be nil")
      end
    end

    it "allows publishing against an exchange" do
      expect(subject.publish("amqp_client_test_exchange", "#", "some body"))
        .to_not be_nil
    end
  end
end
