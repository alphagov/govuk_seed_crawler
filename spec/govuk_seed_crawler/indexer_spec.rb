require "spec_helper"

describe GovukSeedCrawler::Indexer do
  let(:mock_parser) { instance_double(SitemapParser, to_a: []) }

  it "responds to Indexer#urls" do
    allow(SitemapParser).to receive(:new).and_return(mock_parser)
    expect(described_class.new("https://example.com")).to respond_to(:urls)
  end

  it "calls SitemapParser with the sitemap file" do
    allow(SitemapParser).to receive(:new).with("https://example.com/sitemap.xml", { recurse: true }).and_return(mock_parser)
    described_class.new("https://example.com")
    expect(SitemapParser).to have_received(:new)
  end
end
