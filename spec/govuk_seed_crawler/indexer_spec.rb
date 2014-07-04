require 'spec_helper'

describe GovukSeedCrawler::Indexer do
  subject { GovukSeedCrawler::Indexer.new('https://example.com/') }

  context "under normal usage" do
    let(:mock_indexer) do
      double(:mock_indexer, :all_start_urls => [])
    end

    it "responds to Indexer#urls" do
      allow(GovukMirrorer::Indexer).to receive(:new).and_return(mock_indexer)
      expect(subject).to respond_to(:urls)
    end

    it "calls GovukMirrorer::Indexer with the site root" do
      expect(GovukMirrorer::Indexer).to receive(:new).with('https://example.com/').and_return(mock_indexer)
      subject
    end
  end
end
