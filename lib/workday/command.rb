module Workday
  class Command
    def command(**options)
      require "tty-command"
      TTY::Command.new(options)
    end

    def configurator
      require "tty-config"
      config = TTY::Config.new
      config.filename = "config"
      config.extname = ".json"
      config.append_path Dir.pwd
      config.read
      config
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

    def spinner(format: "dots")
      require "tty-spinner"
      TTY::Spinner.new(format: format)
    end

    def table
      require "tty-table"
      TTY::Table
    end
  end
end
