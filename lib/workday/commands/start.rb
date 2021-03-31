# frozen_string_literal: true

require_relative "../command"
require_relative "../pco_apps"
require_relative "../pco_box"
require_relative "../additional_apps"
require_relative "slack"

module Workday
  module Commands
    class Start < Workday::Command
      def initialize(options)
        @options = options
      end

      def execute
        Slack.new(options).execute unless options[:skip_slack]
        # Disable DND
        PcoApps.before_update unless options[:skip_update_apps]
        box = PcoBox.new
        box.update unless options[:skip_update_box]
        box.update_apps(options[:skip_webpack]) unless options[:skip_update_apps]
        PcoApps.after_update unless options[:skip_update_apps]
        box.start if options[:skip_update_box]
        AdditionalApps.open
        prompt.say "Happy hacking! 🙂", color: :on_bright_green
      end

      private

      attr_reader :options
    end
  end
end
