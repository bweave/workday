# frozen_string_literal: true

require "thor"
require_relative "command"

module Workday
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    class_option :debug, type: :boolean, default: false, desc: "Run in debug mode: posts all Slack messages to @YOURSELF"

    desc "version", "workday version"
    def version
      require_relative "version"
      puts "v#{Workday::VERSION}"
    end
    map %w[--version -v] => :version

    desc "start", "Start your Planning Center work day"
    method_option :help, aliases: "-h", type: :boolean, desc: "Display usage information"
    method_option :skip_slack, type: :boolean, aliases: "-s", desc: "Skip sending a message to Slack"
    method_option :skip_update_apps, type: :boolean, aliases: "-a", desc: "Skip updating PCO app codebases"
    method_option :skip_update_box, type: :boolean, aliases: "-b", desc: "Skip updating pco-box"
    method_option :skip_webpack, type: :boolean, aliases: "-w", desc: "Skip running webpack when updating apps"
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
    method_option :skip_slack, type: :boolean, aliases: "-s", desc: "Skip sending a message to Slack"
    method_option :skip_apps_close, type: :boolean, aliases: "-a", desc: "Skip close additional apps"
    method_option :skip_box_stop, type: :boolean, aliases: "-b", desc: "Skip box stop"
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

    desc "slack", "Post a Slack message"
    method_option :help, aliases: "-h", type: :boolean, desc: "Display usage information"
    method_option :channel, aliases: "-c", type: :string, desc: "Channel to post in"
    method_option :message, aliases: "-m", type: :string, desc: "Message to post"
    def slack
      if options[:help]
        invoke :help, ["slack"]
      else
        require_relative "commands/slack"
        Workday::Commands::Slack.new(options).execute
      end
    end
  end
end
