module Workday
  class Command
    def configurator
      require "tty-config"
      TTY::Config.new
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
