module Workday
  class Command
    def configurator
      require "tty-config"
      config = TTY::Config.new
      config.filename = "config"
      config.extname = ".json"
      config.append_path Dir.pwd
      config.read
      config
    end

    def pastel
      require "pastel"
      Pastel.new
    end

    def prompt(**options)
      require "tty-prompt"
      TTY::Prompt.new(options)
    end

    def table
      require "tty-table"
      TTY::Table
    end
  end
end
