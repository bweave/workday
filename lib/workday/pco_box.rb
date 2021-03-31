# frozen_string_literal: true

require "json"
require_relative "command"
require_relative "pco_box/locations"

module Workday
  class PcoBox < Workday::Command
    include Locations

    def initialize(options)
      @options = options
      @location = location_from_config.new(options)
    end

    def update
      prompt.say "⚙️  Updating pco-box", color: :bright_green
      cmd = ["cd ~/pco-box", "git pull", "bin/box update"].join(";")
      location.run cmd
    end

    def update_apps(skip_webpack)
      prompt.say "⚙️  Updating apps", color: :bright_green
      cmd = ["~/pco-box/bin/box update-apps --auto-master"]
      cmd << "--skip-webpack" if skip_webpack
      location.run cmd.join(" ")
    end

    def start
      prompt.say "🚀 Starting box", color: :bright_green
      location.run "~/pco-box/bin/box start"
    end

    def stop
      prompt.say "🛑 Shutting down box", color: :bright_green
      location.run "~/pco-box/bin/box start"
    end

    private

    attr_reader :options
    attr_reader :location
  end
end
