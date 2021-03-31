# frozen_string_literal: true

require "date"
require_relative "../command"
require_relative "../additional_apps"
require_relative "../pco_box"
require_relative "slack"

module Workday
  module Commands
    class End < Workday::Command
      def initialize(options)
        @options = options
      end

      def execute
        Slack.new(options.merge("message" => signoff_message)).execute unless options["skip_slack"]
        spinner.run("\n👋 Until next time.") do
          PcoBox.new(options).stop unless options[:skip_box_stop]
          AdditionalApps.new(options).close unless options[:skip_apps_close]
        end
      end

      private

      attr_reader :options

      def signoff_message
        default = friday? ? "👋 Have a great weekend!" : "👋 Cya tomorrow!"
        prompt.ask("Signoff message:", default: default, help_color: :cyan)
      end

      def friday?
        Date.today.wday == 5
      end
    end
  end
end
