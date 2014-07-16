module GovukSeedCrawler
  class CLIRunner
    def initialize(argv_array)
      begin
        @options, @site_root = CLIParser.new(argv_array).parse
      rescue CLIException => e
        puts e.message
        puts e.help
        exit 2
      end

      set_logging_level(@options.to_hash)
    end

    def run
      Seeder::seed(@site_root, @options.to_hash)
    end

    private

    def set_logging_level(cli_options)
      if cli_options[:verbose]
        GovukSeedCrawler.logger.level = Logger::DEBUG
      elsif cli_options[:quiet]
        GovukSeedCrawler.logger.level = Logger::ERROR
      end
    end
  end
end
