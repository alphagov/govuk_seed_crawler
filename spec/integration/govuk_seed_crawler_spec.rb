require 'json'
require 'spec_helper'

describe GovukSeedCrawler do
  def stub_api_artefacts(count)
    item = {
      "id" => "https://www.gov.uk/api/government%2Fnews%2Ffaster-review-of-support-for-renewable-electricity-to-provide-investor-certainty.json",
      "web_url" => "https://www.gov.uk/government/news/faster-review-of-support-for-renewable-electricity-to-provide-investor-certainty",
      "title" => "Faster review of support for Renewable electricity to provide investor certainty",
      "format" => "announcement"
    }
    results = count.times.collect { item }
    response = {
      "_response_info" => {
        "status" => "ok",
        "links" => []
      },
      "total" => results.size,
      "start_index" => 1,
      "page_size" => 100,
      "current_page" => 1,
      "pages" => 1,
      "results" => results
    }

    stub_request(:get, "https://www.gov.uk//api/artefacts.json").
         to_return(:status => 200, :body => response.to_json, :headers => {})
  end

  let(:vhost) { "/" }
  let(:exchange_name) { "govuk_seed_crawler_integration_exchange" }
  let(:queue_name) { "govuk_seed_crawler_integration_queue" }
  let(:topic) { "#" }
  let(:site_root) { "https://www.gov.uk/" }
  let(:options) {{
      :host => "localhost",
      :user => "govuk_seed_crawler",
      :pass => "govuk_seed_crawler",
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
    stub_api_artefacts(10)
    subject

    # There's an extra 5 URLs from the Indexer class that are hard-coded.
    expect(@queue.message_count).to be(15)
  end
end
