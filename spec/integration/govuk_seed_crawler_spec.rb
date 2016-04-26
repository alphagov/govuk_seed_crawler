require 'json'
require 'spec_helper'

describe GovukSeedCrawler do
  def stub_sitemap
    sitemap = %{<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://www.gov.uk/</loc>
  </url>
  <url>
    <loc>https://www.gov.uk/register-to-vote</loc>
  </url>
  <url>
    <loc>https://www.gov.uk/help</loc>
  </url>
</urlset>
    }

    stub_request(:get, "https://www.gov.uk/sitemap.xml").
         to_return(:status => 200, :body => sitemap, :headers => {})
  end

  let(:vhost) { "/" }
  let(:exchange_name) { "govuk_seed_crawler_integration_exchange" }
  let(:queue_name) { "govuk_seed_crawler_integration_queue" }
  let(:topic) { "#" }
  let(:site_root) { "https://www.gov.uk" }
  let(:options) {{
      :host => ENV.fetch("AMQP_HOST", "localhost"),
      :user => ENV.fetch("AMQP_USER", "govuk_seed_crawler"),
      :pass => ENV.fetch("AMQP_PASS", "govuk_seed_crawler"),
      :exchange => exchange_name,
      :topic => topic
  }}
  let(:rabbitmq_client) { GovukSeedCrawler::AmqpClient.new(options) }

  subject { GovukSeedCrawler::Seeder::seed(site_root, options) }

  before(:each) do
    @exchange = rabbitmq_client.channel.topic(exchange_name, :durable => true)
    @queue = rabbitmq_client.channel.queue(queue_name)
    @queue.bind(@exchange, :routing_key => topic)
  end

  after(:each) do
    @queue.unbind(@exchange)
    @queue.delete
    @exchange.delete
    rabbitmq_client.close
  end

  it "publishes URLs it finds to an AMQP topic exchange" do
    stub_sitemap
    subject

    expect(@queue.message_count).to be(3)
  end
end
