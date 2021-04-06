# frozen_string_literal: true

module Workday
  class Command
    def command(**args)
      require "tty-command"
      printer = options.debug? ? :pretty : :null
      TTY::Command.new({printer: printer}.merge(args))
    end

    def configurator
      require "tty-config"
      config = TTY::Config.new
      config.filename = "config"
      config.extname = ".json"
      config.append_path(File.join(Dir.home, ".config", "workday"))
      config.read
      config
    end

    def font(face = :doom)
      require "tty-font"
      TTY::Font.new(face)
    end

    def pager
      require "tty-pager"
      TTY::Pager.new
    end

    def pastel
      require "pastel"
      Pastel.new
    end

    def prompt(**options)
      require "tty-prompt"
      TTY::Prompt.new({help_color: :cyan}.merge(options))
    end

    def slack_client
      require "slack-ruby-client"
      @slack_client ||= Slack::Web::Client.new(token: ENV.fetch("SLACK_API_TOKEN"))
    end

    def spinner(name = "", **args)
      require "tty-spinner"
      TTY::Spinner.new(":spinner #{name}", {format: :dots}.merge(**args))
    end

    def table
      require "tty-table"
      TTY::Table
    end
  end
end
