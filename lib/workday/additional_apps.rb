# frozen_string_literal: true

require_relative "command"

module Workday
  class AdditionalApps < Workday::Command
    def self.open
      new.open
    end

    def self.close
      new.close
    end

    def initialize
      @apps = configurator.fetch(:additional_apps)
    end

    def open
      apps
        .select { |a| a["enabled"] }
        .each { |a| command.run("osascript -e 'tell application \"#{a["name"]}\" to activate'") }
    end

    def close
      apps
        .select { |a| a["enabled"] }
        .each { |a| command.run("osascript -e 'tell application \"#{a["name"]}\" to quit'") }
    end

    private

    attr_reader :apps
  end
end
