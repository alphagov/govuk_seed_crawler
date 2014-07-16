require 'slop'

module GovukSeedCrawler
  class CLIException < StandardError
    attr_reader :help

    def initialize(message, help)
      super(message)
      @help = help
    end
  end

  class CLIParser
    DEFAULTS = {
      :exchange => "govuk_crawler_exchange",
      :help => nil,
      :host => "localhost",
      :password => "guest",
      :port => "5672",
      :quiet => false,
      :topic => "#",
      :username => "guest",
      :verbose => false,
      :version => nil
    }.freeze

    def initialize(argv_array)
      @argv_array = argv_array
    end

    def parse
      opts = Slop.parse!(@argv_array, :help => true) do
        banner <<-EOS
Usage: #{$PROGRAM_NAME} site_root [options]

Seeds an AMQP topic exchange with messages, each containing a URL, for the GOV.UK Crawler Worker
to consume:

https://github.com/alphagov/govuk_crawler_worker
        EOS

        on :version, "Display version and exit" do
          puts "Version: #{GovukSeedCrawler::VERSION}"
        end

        on :host=, "AMQP host to publish to", default: DEFAULTS[:host]
        on :port=, "AMQP port", default: DEFAULTS[:port]
        on :username=, "AMQP username", default: DEFAULTS[:username]
        on :password=, "AMQP password", default: DEFAULTS[:password]
        on :exchange=, "AMQP exchange", default: DEFAULTS[:exchange]
        on :topic=, "AMQP topic", default: DEFAULTS[:topic]
        on :quiet, "Quiet output", default: DEFAULTS[:quiet]
        on :verbose, "Verbose output", default: DEFAULTS[:verbose]
      end

      if opts[:version].nil?
        raise CLIException.new("too many arguments provided", opts.help) if @argv_array.size > 1
        raise CLIException.new("site_root must be provided", opts.help) if @argv_array.size != 1
      end

      return opts, @argv_array.first
    end
  end
end
