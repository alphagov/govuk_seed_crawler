require 'spec_helper'

describe GovukSeedCrawler::Indexer do
  subject { GovukSeedCrawler::Indexer.new('https://example.com') }

  context "under normal usage" do
    let(:mock_parser) do
      double(:mock_parser, :to_a => [])
    end

    it "responds to Indexer#urls" do
      allow(SitemapParser).to receive(:new).and_return(mock_parser)
      expect(subject).to respond_to(:urls)
    end

    it "calls SitemapParser with the sitemap file" do
      expect(SitemapParser).to receive(:new).with('https://example.com/sitemap.xml', {:recurse => true}).and_return(mock_parser)
      subject
    end
  end
end
