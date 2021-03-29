require "thor"
require_relative "command"

module Workday
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc "version", "workday version"
    def version
      require_relative "version"
      puts "v#{Workday::VERSION}"
    end
    map %w[--version -v] => :version

    desc "start", "Start your Planning Center work day"
    method_option :help, aliases: "-h", type: :boolean, desc: "Display usage information"
    def start
      if options[:help]
        invoke :help, ["start"]
      else
        require_relative "commands/start"
        Workday::Commands::Start.new(options).execute
      end
    end

    desc "end", "End your Planning Center work day"
    method_option :help, aliases: "-h", type: :boolean, desc: "Display usage information"
    def end
      if options[:help]
        invoke :help, ["end"]
      else
        require_relative "commands/end"
        Workday::Commands::End.new(options).execute
      end
    end

    require_relative "commands/config"
    register Workday::Commands::Config, "config", "config [SUBCOMMAND]", "Manage configuration option"
  end
end
