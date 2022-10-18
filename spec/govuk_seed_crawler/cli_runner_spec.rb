require "spec_helper"

describe GovukSeedCrawler::CLIRunner do
  describe "printing the version" do
    it "does not try to connect to an AMQP server" do
      expect(Bunny).not_to receive(:new)

      expect { described_class.new(["--version"]).run }
        .to output("Version: #{GovukSeedCrawler::VERSION}\n").to_stdout
        .and raise_exception(SystemExit) { |e| expect(e.status).to eq(0) }
    end
  end

  describe "catching any CLIException objects and exiting with a status 1" do
    it "prints to STDOUT for too many arguments" do
      expect { described_class.new(%w[a b]).run }
        .to output(/\Atoo many arguments provided/).to_stdout
        .and raise_exception(SystemExit) { |e| expect(e.status).to eq(2) }
    end

    it "prints to STDOUT when site_root not set" do
      expect { described_class.new(["--verbose"]).run }
        .to output(/\Asite_root must be provided/).to_stdout
        .and raise_exception(SystemExit) { |e| expect(e.status).to eq(2) }
    end
  end

  describe "setting the logging level" do
    before do
      GovukSeedCrawler.logger.level = Logger::INFO
    end

    it "defaults to INFO" do
      described_class.new(["http://www.example.com"])
      expect(GovukSeedCrawler.logger.level).to eq(Logger::INFO)
    end

    it "sets to ERROR for quite" do
      described_class.new(["http://www.example.com", "--quiet"])
      expect(GovukSeedCrawler.logger.level).to eq(Logger::ERROR)
    end

    it "sets to DEBUG for verbose" do
      described_class.new(["http://www.example.com", "--verbose"])
      expect(GovukSeedCrawler.logger.level).to eq(Logger::DEBUG)
    end
  end

  describe "#run" do
    it "passes all options through to seed" do
      expect(GovukSeedCrawler::Seeder).to receive(:seed)
        .with("http://www.example.com", GovukSeedCrawler::CLIParser::DEFAULTS).once
      described_class.new(["http://www.example.com"]).run
    end
  end
end
