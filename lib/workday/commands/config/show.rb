# frozen_string_literal: true

require_relative "../../command"

module Workday
  module Commands
    class Config
      class Show < Workday::Command
        def initialize(options)
          @options = options
          @config = configurator
          config.filename = "config"
          config.extname = ".json"
          config.append_path Dir.pwd
          config.read
        end

        def execute(input: $stdin, output: $stdout)
          # TODO: maybe use tty-pager for this output?
          prompt.ok "Slack"
          output.puts show_slack
          prompt.ok "Other Apps:"
          output.puts show_other_apps
        end

        private

        attr_reader :config

        def show_slack
          data = config.fetch(:slack).merge(api_token: ENV["SLACK_API_TOKEN"]).to_a
          table.new(data).render(:unicode) do |r|
            r.border.separator = :each_row
            r.padding = [0, 1]
            r.resize = true
          end
        end

        def show_other_apps
          data = config.fetch(:other_apps)
          table.new(header: %w[Name Enabled?], rows: data.map(&:values)).render(:unicode) do |r|
            r.border.separator = :each_row
            r.padding = [0, 1]
            r.resize = true
            r.filter = ->(val, row_index, col_index) do
              col_index == 1 && val.strip == "true" ? pastel.black.on_green(val) : val
            end
          end
        end
      end
    end
  end
end
