# frozen_string_literal: true

require_relative "../../command"

module Workday
  module Commands
    class Config
      class Setup < Workday::Command
        def initialize(options)
          @options = options
          @config = configurator
          config.filename = "config"
          config.extname = ".json"
          config.append_path Dir.pwd
          config.read
        end

        def execute(input: $stdin, output: $stdout)
          slack = setup_slack
          config.set(:slack, value: slack)

          other_apps = select_apps_to_start_day_with
          config.set(:other_apps, value: other_apps)

          config.write force: true
          prompt.ok "✅ Config updated."
        end

        private

        attr_reader :config

        def setup_slack
          ensure_slack_api_token_present
          channel = prompt.ask("What is your team's Slack channel (For example: #cca-publishing-team)?", value: config.fetch(:slack, :channel))
          icon_url = prompt.ask("What's the URL to the icon you'd like to use when posting messages? (Optional)", value: config.fetch(:slack, :icon_url))
          {channel: channel, icon_url: icon_url}
        end

        def ensure_slack_api_token_present
          return unless ENV["SLACK_API_TOKEN"].nil?

          prompt.warn "You'll need to setup and Environment variable `SLACK_API_TOKEN`."
          prompt.say "You can obtain a Slack API token here: https://api.slack.com/custom-integrations/legacy-tokens."
          prompt.say "Check the README for more info."
          prompt.keypress("When you've done that, press enter to continue", keys: [:return])
          ensure_slack_api_token_present
        end

        def select_apps_to_start_day_with
          apps = config.fetch(:other_apps)
          all_apps = apps.map { |a| a["name"] }
          currently_enabled_apps = apps.select { |a| a["enabled"] }.map { |a| a["name"] }
          selected_apps = prompt.multi_select("Select apps you'd like to start your day with?", all_apps, default: currently_enabled_apps)
          apps.map do |app|
            app["enabled"] = selected_apps.include?(app["name"])
            app
          end
        end
      end
    end
  end
end
