# frozen_string_literal: true

require_relative "../command"

module Workday
  module Commands
    class Start < Workday::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Post to Slack
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
