# frozen_string_literal: true

require_relative "../command"

module Workday
  module Commands
    class End < Workday::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Post to Slack
        # Enable DND
        # Box stop
        # Close additional apps
        prompt.say "END"
      end

      private

      attr_reader :options
    end
  end
end
