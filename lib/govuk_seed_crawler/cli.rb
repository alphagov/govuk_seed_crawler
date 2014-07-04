require 'optparse'

module GovukSeedCrawler
  class Cli
    def initialize(argv_array)
      @options = {
        :amqp_host => "localhost",
        :amqp_port => "5672",
        :amqp_username => "guest",
        :amqp_password => "guest",
        :amqp_exchange => "govuk_crawler_exchange",
        :amqp_topic => "#",
        :quiet => false,
        :verbose => false,
      }

      parse(argv_array)
      set_logging_level(@options)
    end

    def run
      Seeder::seed(@options)
    end

    private

    def parse(args)
      opt_parser = OptionParser.new do |opts|
        opts.banner = <<-EOS
Usage: #{$PROGRAM_NAME} site_root [options]

Seeds an AMQP topic exchange with messages, each containing a URL, for the GOV.UK Crawler Worker
to consume:

https://github.com/alphagov/govuk_crawler_worker
        EOS

        opts.separator ""
        opts.separator "Options:"

        opts.on("--host HOST", "AMQP host to publish to, defaults to '#{@options[:amqp_host]}'") do |host|
          @options[:amqp_host] = host
        end

        opts.on("--port PORT", "AMQP port, defaults to '#{@options[:amqp_port]}'") do |port|
          @options[:amqp_port] = port
        end

        opts.on("--username USERNAME", "AMQP username, defaults to '#{@options[:amqp_username]}'") do |username|
          @options[:amqp_username] = username
        end

        opts.on("--password PASSWORD", "AMQP password, defaults to '#{@options[:amqp_password]}'") do |password|
          @options[:amqp_password] = password
        end

        opts.on("--exchange EXCHANGE", "AMQP exchange, defaults to '#{@options[:amqp_exchange]}'") do |exchange|
          @options[:amqp_exchange] = exchange
        end

        opts.on("--topic TOPIC", "AMQP topic, defaults to '#{@options[:amqp_topic]}'") do |topic|
          @options[:amqp_topic] = topic
        end

        opts.on("--quiet", "Quiet output, defaults to '#{@options[:quiet]}'") do |_quiet|
          @options[:quiet] = true
        end

        opts.on("--verbose", "Verbose output, defaults to '#{@options[:verbose]}'") do |_verbose|
          @options[:verbose] = true
        end

        opts.on("-h", "--help", "Print usage and exit") do
          $stderr.puts opts
          exit
        end

        opts.on("--version", "Display version and exit") do
          puts GovukSeedCrawler::VERSION
          exit
        end
      end

      @usage_text = opt_parser.to_s
      begin
        opt_parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        exit_error_usage(e)
      end

      case
      when args.size == 0
        exit_error_usage("must supply site_root")
      when args.size > 1
        exit_error_usage("too many arguments")
      end

      @options[:site_root] = args.first
    end

    def exit_error_usage(error)
      $stderr.puts "#{$PROGRAM_NAME}: #{error}"
      $stderr.puts @usage_text
      exit 2
    end

    def set_logging_level(cli_options)
      if cli_options[:verbose]
        GovukSeedCrawler.logger.level = Logger::DEBUG
      elsif cli_options[:quiet]
        GovukSeedCrawler.logger.level = Logger::ERROR
      end
    end
  end
end
