require 'spec_helper'

describe GovukSeedCrawler::CLIRunner do
  describe "catching any CLIException objects and exiting with a status 1" do
    it "prints to STDOUT for too many arguments" do
      temp_stdout do |caught_stdout|
        expect {
          GovukSeedCrawler::CLIRunner.new(["a", "b"])
        }.to raise_exception(SystemExit) { |exit|
          expect(exit.status).to eq(2)
        }

        expect(caught_stdout.strip).to include("too many arguments provided")
      end
    end

    it "prints to STDOUT when site_root not set" do
      temp_stdout do |caught_stdout|
        expect {
          GovukSeedCrawler::CLIRunner.new(["--verbose"])
        }.to raise_exception(SystemExit) { |exit|
          expect(exit.status).to eq(2)
        }

        expect(caught_stdout.strip).to include("site_root must be provided")
      end
    end
  end

  describe "setting the logging level" do
    before do
      GovukSeedCrawler.logger.level = Logger::INFO
    end

    it "defaults to INFO" do
      GovukSeedCrawler::CLIRunner.new(["http://www.example.com"])
      expect(GovukSeedCrawler.logger.level).to eq(Logger::INFO)
    end

    it "sets to ERROR for quite" do
      GovukSeedCrawler::CLIRunner.new(["http://www.example.com", "--quiet"])
      expect(GovukSeedCrawler.logger.level).to eq(Logger::ERROR)
    end

    it "sets to DEBUG for verbose" do
      GovukSeedCrawler::CLIRunner.new(["http://www.example.com", "--verbose"])
      expect(GovukSeedCrawler.logger.level).to eq(Logger::DEBUG)
    end
  end

  describe "#run" do
    it "passes all options through to seed" do
      expect(GovukSeedCrawler::Seeder).to receive(:seed).
        with("http://www.example.com", GovukSeedCrawler::CLIParser::DEFAULTS).once
      GovukSeedCrawler::CLIRunner.new(["http://www.example.com"]).run
    end
  end
end
