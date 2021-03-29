# frozen_string_literal: true

require "date"
require_relative "../command"
require_relative "slack"

module Workday
  module Commands
    class End < Workday::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Post to Slack
        Slack.new("message" => signoff_message).execute unless options["skip_slack"]
        # Enable DND
        # Box stop
        # Close additional apps
        prompt.say "END"
      end

      private

      attr_reader :options

      def signoff_message
        default = friday? ? "👋 Have a great weekend!" : "👋 Cya tomorrow!"
        prompt.ask("Signoff message:", value: default)
      end

      def friday?
        Date.today.wday == 5
      end
    end
  end
end
