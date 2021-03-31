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
        spinner.run("\n🙂 Happy hacking!") do |spinner|
          pco_apps = PcoApps.new(options)
          box = PcoBox.new(options)

          pco_apps .before_update unless options[:skip_update_apps]
          box.update unless options[:skip_update_box]
          box.update_apps(options[:skip_webpack]) unless options[:skip_update_apps]
          pco_apps.after_update unless options[:skip_update_apps]
          box.start if options[:skip_update_box]
          AdditionalApps.new(options).open
        end
      end

      private

      attr_reader :options
    end
  end
end
