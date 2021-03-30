# frozen_string_literal: true

require_relative "command"

module Workday
  class PcoBox < Workday::Command
    def self.update
      new.update
    end

    def self.update_apps(skip_webpack)
      new.update_apps(skip_webpack)
    end

    def self.start
      new.start
    end

    def self.stop
      new.stop
    end

    def update
      prompt.say "⚙️  Updating pco-box", color: :on_bright_green
      Dir.chdir("#{ENV.fetch("HOME")}/pco-box") do
        command.run!("git pull")
        command.run!("bin/box update", pty: true)
      end
    end

    def update_apps(skip_webpack)
      prompt.say "⚙️  Updating apps", color: :on_bright_green
      args = %w[box update-apps --auto-master]
      args << "--skip-webpack" if skip_webpack
      command.run!(*args, pty: true)
    end

    def start
      prompt.say "⚙️  starting box", color: :on_bright_green
      command.run!("box start")
    end

    def stop
      prompt.say "⚙️  shutting down box", color: :on_bright_green
      command.run!("box stop")
    end
  end
end
