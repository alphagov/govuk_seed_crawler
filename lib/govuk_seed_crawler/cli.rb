require 'optparse'

module GovukSeedCrawler
  class Cli
    def initialize(argv_array)
      @options = {
        :amqp_host => nil,
        :amqp_username => nil,
        :amqp_password => nil,
        :amqp_exchange => nil,
        :amqp_topic => nil,
      }

      parse(argv_array)
    end

    def run
      Seeder::seed(@options)
    end

    private

    def parse(args)
      opt_parser = OptionParser.new do |opts|
        opts.banner = <<-EOS
Usage: #{$0} site_root [options]

Seeds an AMQP topic exchange with messages, each containing a URL, for the GOV.UK Crawler Worker
to consume:

https://github.com/alphagov/govuk_crawler_worker
        EOS

        opts.separator ""
        opts.separator "Options:"

        opts.on("--host HOST", "AMQP host to publish to") do |host|
          @options[:amqp_host] = host
        end

        opts.on("--username USERNAME", "AMQP username") do |username|
          @options[:amqp_username] = username
        end

        opts.on("--password PASSWORD", "AMQP password") do |password|
          @options[:amqp_password] = password
        end

        opts.on("--exchange EXCHANGE", "AMQP exchange") do |exchange|
          @options[:amqp_exchange] = exchange
        end

        opts.on("--topic TOPIC", "AMQP topic") do |topic|
          @options[:amqp_topic] = topic
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

      exit_error_usage("must supply site_root") unless args.size == 1
      @options[:site_root] = args.first
    end

    def exit_error_usage(error)
      $stderr.puts "#{$0}: #{error}"
      $stderr.puts @usage_text
      exit 2
    end
  end
end
