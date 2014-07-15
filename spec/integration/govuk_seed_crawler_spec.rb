require 'json'
require 'spec_helper'
require 'rabbitmq/http/client'

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
  let(:exchange) { "govuk_seed_crawler_integration_exchange" }
  let(:queue) { "govuk_seed_crawler_integration_queue" }
  let(:topic) { "#" }
  let(:options) {{
      :amqp_exchange => exchange,
      :amqp_topic => topic,
      :site_root => "https://www.gov.uk/",
  }}
  let(:rabbitmq_client) { RabbitMQ::HTTP::Client.new("http://guest:guest@127.0.0.1:15672") }

  subject { GovukSeedCrawler::Seeder::seed(options) }

  before(:each) do
    rabbitmq_client.declare_exchange(vhost, exchange, { :type => "topic" })
    rabbitmq_client.declare_queue(vhost, queue, {})
    rabbitmq_client.bind_queue(vhost, queue, exchange, "#")
  end

  after(:each) do
    rabbitmq_client.delete_queue_binding(vhost, queue, exchange, "#")
    rabbitmq_client.delete_exchange(vhost, exchange)
    rabbitmq_client.delete_queue(vhost, queue)
  end

  it "publishes URLs it finds to an AMQP topic exchange" do
    stub_api_artefacts(10)

    subject

    # Give the management API time to recognise the messages we've
    # just published.
    sleep(1)

    messages = rabbitmq_client.get_messages(
      vhost, queue, :count => 10000, :requeue => false, :encoding => "auto")

    # There's an extra 5 URLs from the Indexer class that are hard-coded.
    expect(messages.size).to be(15)
  end
end
