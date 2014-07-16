require 'spec_helper'

describe GovukSeedCrawler::CLIParser do
  it "requires the site_root to be provided" do
    expect {
      GovukSeedCrawler::CLIParser.new([]).parse
    }.to raise_exception(GovukSeedCrawler::CLIException, "site_root must be provided")
  end

  it "provides the defaults when just given the site_root" do
    options, site_root = GovukSeedCrawler::CLIParser.new(["https://www.example.com"]).parse

    expect(options.to_hash).to eq(GovukSeedCrawler::CLIParser::DEFAULTS)
    expect(site_root).to eq("https://www.example.com")
  end

  it "should tell us when we've given too many arguments" do
    expect {
      GovukSeedCrawler::CLIParser.new(["a", "b"]).parse
    }.to raise_exception(GovukSeedCrawler::CLIException, "too many arguments provided")
  end

  it "should nest the help message in with any CLIExceptions we raise" do
    expect {
      GovukSeedCrawler::CLIParser.new(["a", "b"]).parse
    }.to raise_exception(GovukSeedCrawler::CLIException) { |e|
      expect(e.help).to include("Usage: ")
    }
  end

  describe "catching STDOUT" do
    it "shows the help banner when provided -h" do
      # Get a valid options response as help closes early with SystemExit.
      options, _ = GovukSeedCrawler::CLIParser.new(["http://www.foo.com/"]).parse

      temp_stdout do |caught_stdout|
        expect {
          _, _ = GovukSeedCrawler::CLIParser.new(["-h"]).parse
        }.to raise_exception(SystemExit) { |e|
          expect(e.status).to eq(0)
        }

        expect(caught_stdout.strip).to eq(options.help)
      end
    end

    it "should show the version number and exit" do
      temp_stdout do |caught_stdout|
        _, _ = GovukSeedCrawler::CLIParser.new(["--version"]).parse
        expect(caught_stdout.strip).to eq("Version: #{GovukSeedCrawler::VERSION}")
      end
    end
  end

  describe "passing in valid arguments" do
    let(:arguments) {
      [
       "https://www.override.com/",
       "--host rabbitmq.some.custom.vhost",
       "--port 4567",
       "--username foo",
       "--password bar",
       "--exchange some_custom_exchange",
       "--topic some_custom_topic",
       "--verbose"
      ].join(" ").split(" ")
    }

    it "should override all of the default arguments that we're providing" do
      overriden = {
        host: "rabbitmq.some.custom.vhost",
        port: "4567",
        username: "foo",
        password: "bar",
        exchange: "some_custom_exchange",
        topic: "some_custom_topic",
        help: nil,
        quiet: false,
        verbose: true,
        version: nil
      }

      expect(GovukSeedCrawler::CLIParser.new(arguments).parse.first.to_hash).to eq(overriden)
    end

    it "should set the --quiet value" do
      options, _ = GovukSeedCrawler::CLIParser.new(["foo.com", "--quiet"]).parse
      expect(options.to_hash).to eq(GovukSeedCrawler::CLIParser::DEFAULTS.merge(quiet: true))
    end
  end
end
