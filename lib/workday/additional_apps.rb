# frozen_string_literal: true

require_relative "command"

module Workday
  class AdditionalApps < Workday::Command
    def initialize(options)
      @options = options
      @apps = configurator.fetch(:additional_apps).map { |a| a.transform_keys!(&:to_sym) }
    end

    def open
      apps
        .select { |a| a[:enabled] }
        .each { |a| command.run("osascript -e 'tell application \"#{a[:name]}\" to activate'") }
      prompt.say "Additional apps open", color: :bright_green
    end

    def close
      apps
        .select { |a| a[:enabled] }
        .each { |a| command.run("osascript -e 'tell application \"#{a[:name]}\" to quit'") }
      prompt.say "Additional apps closed", color: :bright_green
    end

    private

    attr_reader :options
    attr_reader :apps
  end
end
