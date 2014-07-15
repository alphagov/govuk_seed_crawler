require 'spec_helper'

describe "passing in bad AMQP connection parameters" do
  it "should raise a connection exception" do
    expect {
      GovukSeedCrawler::UrlPublisher.new({:host => "bad.amqp.hostname"}, "", "")
    }.to raise_exception(Bunny::TCPConnectionFailed)
  end
end
