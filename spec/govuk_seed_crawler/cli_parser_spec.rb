require "spec_helper"

describe GovukSeedCrawler::CLIParser do
  it "requires the site_root to be provided" do
    expect {
      described_class.new([]).parse
    }.to raise_exception(GovukSeedCrawler::CLIException, "site_root must be provided")
  end

  it "provides the defaults when just given the site_root" do
    options, site_root = described_class.new(["https://www.example.com"]).parse

    expect(options).to eq(GovukSeedCrawler::CLIParser::DEFAULTS)
    expect(site_root).to eq("https://www.example.com")
  end

  it "tells us when we've given too many arguments" do
    expect {
      described_class.new(%w[a b]).parse
    }.to raise_exception(GovukSeedCrawler::CLIException, "too many arguments provided")
  end

  it "nests the help message in with any CLIExceptions we raise" do
    expect {
      described_class.new(%w[a b]).parse
    }.to raise_exception(GovukSeedCrawler::CLIException) { |e|
      expect(e.help).to include("Usage: ")
    }
  end

  describe "catching STDOUT" do
    it "shows the help banner when provided -h" do
      # Get a valid options response as help closes early with SystemExit.
      options = described_class.new(["http://www.foo.com/"]).options

      expect { described_class.new(["-h"]).parse }
        .to output("#{options.help}\n").to_stdout
        .and raise_exception(SystemExit) { |e| expect(e.status).to eq(0) }
    end

    it "shows the version number and exit" do
      expect { described_class.new(["--version"]).parse }
        .to output("Version: #{GovukSeedCrawler::VERSION}\n").to_stdout
        .and raise_exception(SystemExit) { |e| expect(e.status).to eq(0) }
    end
  end

  describe "passing in valid arguments" do
    let(:arguments) do
      [
        "https://www.override.com/",
        "--host rabbitmq.some.custom.vhost",
        "--port 4567",
        "--username foo",
        "--password bar",
        "--exchange some_custom_exchange",
        "--topic some_custom_topic",
        "--vhost a_vhost",
        "--verbose",
      ].join(" ").split(" ")
    end

    it "overrides all of the default arguments that we're providing" do
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
        version: nil,
        vhost: "a_vhost",
      }

      expect(described_class.new(arguments).parse.first).to eq(overriden)
    end

    it "sets the --quiet value" do
      options, = described_class.new(["foo.com", "--quiet"]).parse
      expect(options).to eq(GovukSeedCrawler::CLIParser::DEFAULTS.merge(quiet: true))
    end

    describe "reading the AMQP password from an environment variable" do
      def set_amqp_pass(password)
        ENV[GovukSeedCrawler::CLIParser::ENV_AMQP_PASS_KEY] = password
      end

      after do
        ENV[GovukSeedCrawler::CLIParser::ENV_AMQP_PASS_KEY] = nil
      end

      it "sets the password if set using an environment variable" do
        set_amqp_pass("foobar")

        expect(described_class.new(["http://www.example.com"]).parse.first)
          .to include(password: "foobar")
      end

      it "picks the environment variable over the parameter if both are set" do
        set_amqp_pass("bar")

        expect(described_class.new(["http://www.example.com", "--password", "foo"]).parse.first)
          .to include(password: "bar")
      end
    end
  end
end
