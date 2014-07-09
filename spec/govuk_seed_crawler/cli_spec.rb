require 'spec_helper'

class CommandRun
  attr_accessor :stdout, :stderr, :exitstatus

  def initialize(args)
    out = StringIO.new
    err = StringIO.new

    $stdout = out
    $stderr = err

    begin
      GovukSeedCrawler::Cli.new(args).run
      @exitstatus = 0
    rescue SystemExit => e
      # Capture exit(n) value.
      @exitstatus = e.status
    end

    @stdout = out.string.strip
    @stderr = err.string.strip

    $stdout = STDOUT
    $stderr = STDERR
  end
end

describe GovukSeedCrawler::Cli do
  subject { CommandRun.new(args) }

  default_logging_level = GovukSeedCrawler.logger.level

  before(:each) {
    GovukSeedCrawler.logger.level = default_logging_level
  }

  describe "normal usage" do
    context "when specifying AMQP connection parameters" do
      let (:options) do
        {
          :amqp_host => "localhost",
          :amqp_port => "5672",
          :amqp_username => "guest",
          :amqp_password => "guest",
          :amqp_exchange => "govuk_crawler_exchange",
          :amqp_topic => "#",
          :quiet => false,
          :verbose => false,
          :site_root => "https://example.com/",
        }
      end

      describe "when passed an AMQP host" do
        let(:args) { %w{https://example.com/ --host localhost} }

        it "should instantiate Seeder with the right options" do
          options[:amqp_host] = 'localhost'

          expect(GovukSeedCrawler::Seeder).to receive(:seed).with(options)
          subject
        end
      end

      describe "when passed an AMQP port" do
        let(:args) { %w{https://example.com/ --port 9999} }

        it "should instantiate Seeder with the right options" do
          options[:amqp_port] = '9999'

          expect(GovukSeedCrawler::Seeder).to receive(:seed).with(options)
          subject
        end
      end

      describe "when passed an AMQP username" do
        let(:args) { %w{https://example.com/ --username dirk} }

        it "should instantiate Seeder with the right options" do
          options[:amqp_username] = 'dirk'

          expect(GovukSeedCrawler::Seeder).to receive(:seed).with(options)
          subject
        end
      end

      describe "when passed an AMQP password" do
        let(:args) { %w{https://example.com/ --password lolcats} }

        it "should instantiate Seeder with the right options" do
          options[:amqp_password] = 'lolcats'

          expect(GovukSeedCrawler::Seeder).to receive(:seed).with(options)
          subject
        end
      end

      describe "when passed an AMQP exchange" do
        let(:args) { %w{https://example.com/ --exchange #} }

        it "should instantiate Seeder with the right options" do
          options[:amqp_exchange] = '#'

          expect(GovukSeedCrawler::Seeder).to receive(:seed).with(options)
          subject
        end
      end

      describe "when passed an AMQP topic" do
        let(:args) { %w{https://example.com/ --topic publish} }

        it "should instantiate Seeder with the right options" do
          options[:amqp_topic] = 'publish'

          expect(GovukSeedCrawler::Seeder).to receive(:seed).with(options)
          subject
        end
      end
    end

    context "when asked to be quiet" do
      let(:args) { %w{https://example.com/ --quiet} }

      it "set the logging level to ERROR" do
        allow(GovukSeedCrawler::Seeder).to receive(:seed)
        subject
        expect(GovukSeedCrawler.logger.level).to eq(Logger::ERROR)
      end
    end

    context "when asked to be verbose" do
      let(:args) { %w{https://example.com/ --verbose} }

      it "set the logging level to ERROR" do
        allow(GovukSeedCrawler::Seeder).to receive(:seed)
        subject
        expect(GovukSeedCrawler.logger.level).to eq(Logger::DEBUG)
      end
    end

    context "when asked to be neither quiet nor verbose" do
      let(:args) { %w{https://example.com/} }

      it "set the logging level to INFO" do
        allow(GovukSeedCrawler::Seeder).to receive(:seed)
        subject
        expect(GovukSeedCrawler.logger.level).to eq(Logger::INFO)
      end
    end

    context "when asked to display version" do
      let(:args) { %w{--version} }

      it "should not instantiate Seeder" do
        expect(GovukSeedCrawler::Seeder).not_to receive(:seed)
      end

      it "should print version and exit normally" do
        expect(subject.stdout).to eq(GovukSeedCrawler::VERSION)
        expect(subject.exitstatus).to eq(0)
      end
    end

    context "when asked to display help" do
      let(:args) { %w{https://example.com/ --help} }

      it "should not instantiate Seeder" do
        expect(GovukSeedCrawler::Seeder).not_to receive(:seed)
      end

      it "should print usage and exit normally" do
        expect(subject.stderr).to match(/\AUsage: \S+ site_root \[options\]\n/)
        expect(subject.exitstatus).to eq(0)
      end
    end
  end

  describe "incorrect usage" do
    shared_examples "print usage and exit abnormally" do |error|
      it "should not instantiate Seeder" do
        expect(GovukSeedCrawler::Seeder).not_to receive(:seed)
      end

      it "should print error message and usage" do
        expect(subject.stderr).to match(/\A\S+: #{error}\nUsage: \S+/)
      end

      it "should exit abnormally for incorrect usage" do
        expect(subject.exitstatus).to eq(2)
      end
    end

    context "when given no arguments" do
      let(:args) { %w{} }

      it_behaves_like "print usage and exit abnormally", "must supply site_root"
    end

    context "when given too many arguments" do
      let(:args) { %w{https://example.com howdy} }

      it_behaves_like "print usage and exit abnormally", "too many arguments"
    end

    context "when no site_root is supplied" do
      let(:args) { %w{--host localhost} }

      it_behaves_like "print usage and exit abnormally", "must supply site_root"
    end

    context "when given an unrecognised argument" do
      let(:args) { %w{https://example.com/ --this-is-garbage} }

      it_behaves_like "print usage and exit abnormally", "invalid option: --this-is-garbage"
    end
  end
end
