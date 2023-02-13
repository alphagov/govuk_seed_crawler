require "slop"

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
      exchange: "govuk_crawler_exchange",
      host: "localhost",
      password: "guest",
      port: "5672",
      quiet: false,
      topic: "#",
      username: "guest",
      verbose: false,
      vhost: "/",
    }.freeze

    ENV_AMQP_PASS_KEY = "GOVUK_CRAWLER_AMQP_PASS".freeze

    def initialize(argv_array)
      @argv_array = argv_array
    end

    def options
      opts = Slop::Options.new
      opts.banner = <<~HELP
        Usage: #{$PROGRAM_NAME} site_root [options]

        Seeds an AMQP topic exchange with messages, each containing a URL, for the GOV.UK Crawler Worker
        to consume:

        https://github.com/alphagov/govuk_crawler_worker

        The AMQP password can also be set as an environment variable and will be read from
        `#{ENV_AMQP_PASS_KEY}`. If both the environment variable and command-line option for password
        are set, the environment variable will take higher precedent.
      HELP
      opts.string "--host", "AMQP host to publish to", default: DEFAULTS[:host]
      opts.string "--port", "AMQP port", default: DEFAULTS[:port]
      opts.string "--username", "AMQP username", default: DEFAULTS[:username]
      opts.string "--password", "AMQP password", default: DEFAULTS[:password]
      opts.string "--exchange", "AMQP exchange", default: DEFAULTS[:exchange]
      opts.string "--topic", "AMQP topic", default: DEFAULTS[:topic]
      opts.string "--vhost", "AMQP vhost", default: DEFAULTS[:vhost]
      opts.bool "-q", "--quiet", "Quiet output", default: DEFAULTS[:quiet]
      opts.bool "-v", "--verbose", "Verbose output", default: DEFAULTS[:verbose]
      opts.on "--version", "Display version and exit" do
        puts "Version: #{GovukSeedCrawler::VERSION}"
        exit 0
      end
      opts.on "-h", "--help" do
        puts opts
        exit
      end
      parser = Slop::Parser.new(opts)
      parser.parse(@argv_array)
    end

    def parse
      opts = options

      # opts.arguments shows all arguments NOT processed by the parser,
      # which should just be the first arg (site root).
      # See https://github.com/leejarvis/slop#arguments
      raise CLIException.new("too many arguments provided", opts.to_s) if opts.arguments.count > 1
      raise CLIException.new("site_root must be provided", opts.to_s) if opts.arguments.count.zero?

      options_hash = opts.to_hash
      options_hash[:password] = ENV[ENV_AMQP_PASS_KEY] unless ENV[ENV_AMQP_PASS_KEY].nil?

      [options_hash, @argv_array.first]
    end
  end
end
