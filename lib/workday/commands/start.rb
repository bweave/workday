# frozen_string_literal: true

require_relative "../command"
require_relative "slack"

module Workday
  module Commands
    class Start < Workday::Command
      def initialize(options)
        @options = options
      end

      def execute
        # Post to Slack
        Slack.new({}).execute unless options["skip_slack"]
        # Disable DND
        # WIP any uncommitted work in PCO apps
        # Box update
        # Box update apps
        # UNWIP any apps that got WIP-ed
        # Open additional applications
        prompt.say "START"
      end

      private

      attr_reader :options
    end
  end
end
