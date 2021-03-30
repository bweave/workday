# frozen_string_literal: true

require_relative "../command"
require_relative "../pco_apps"
require_relative "../pco_box"
require_relative "slack"

module Workday
  module Commands
    class Start < Workday::Command
      def initialize(options)
        @options = options
      end

      def execute
        # Post to Slack
        Slack.new({}).execute unless options[:skip_slack]
        # Disable DND
        # WIP any uncommitted work in PCO apps
        PcoApps.before_update unless options[:skip_update_apps]
        # Box update
        PcoBox.update unless options[:skip_update_box]
        # Box update apps
        PcoBox.update_apps(options[:skip_webpack]) unless options[:skip_update_apps]
        # UNWIP any apps that got WIP-ed
        PcoApps.after_update unless options[:skip_update_apps]
        # Open additional applications
        prompt.say "*** ⌨️  Happy hacking! ***", color: :on_bright_green
      end

      private

      attr_reader :options
    end
  end
end
