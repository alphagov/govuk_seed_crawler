describe GovukSeedCrawler::AmqpClient do
  let(:exchange) { "govuk_seed_crawler_spec_exchange" }
  let(:options) do
    {
      host: ENV.fetch("AMQP_HOST", "localhost"),
      user: ENV.fetch("AMQP_USER", "govuk_seed_crawler"),
      pass: ENV.fetch("AMQP_PASS", "govuk_seed_crawler"),
    }
  end

  it "responds to #channel" do
    expect(described_class.new(options)).to respond_to(:channel)
  end

  it "responds to #close" do
    expect(described_class.new(options)).to respond_to(:close)
  end

  it "closes the connection to the AMQP server" do
    mock_bunny = instance_double(Bunny::Session,
                                 start: true,
                                 create_channel: true,
                                 close: true)
    allow(Bunny).to receive(:new).and_return(mock_bunny)
    expect(mock_bunny).to receive(:close).once

    described_class.new(options).close
  end

  describe "#publish" do
    it "raises an exception if exchange is nil" do
      expect {
        described_class.new(options).publish(nil, "#", "some body")
      }.to raise_exception(RuntimeError, "Exchange cannot be nil")
    end

    it "raises an exception if topic is nil" do
      expect {
        described_class.new(options).publish(exchange, nil, "some body")
      }.to raise_exception(RuntimeError, "Topic cannot be nil")
    end

    it "raises an exception if body is nil" do
      expect {
        described_class.new(options).publish(exchange, "#", nil)
      }.to raise_exception(RuntimeError, "Message body cannot be nil")
    end

    it "allows publishing against an exchange" do
      expect(described_class.new(options).publish(exchange, "#", "some body"))
        .not_to be_nil
    end
  end
end
