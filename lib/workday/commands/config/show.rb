# frozen_string_literal: true

require_relative "../../command"

module Workday
  module Commands
    class Config
      class Show < Workday::Command
        def initialize(options)
          @options = options
          @config = configurator
        end

        def execute
          output = <<~OUT
            PCO Box:
            #{show_pco_box}
            Slack:
            #{show_slack}
            Additional Apps:
            #{show_additional_apps}
          OUT
          pager.page output
        end

        private

        attr_reader :config

        def show_pco_box
          table.new(config.fetch(:pco_box).to_a).render(:unicode) do |r|
            r.border.separator = :each_row
          end
        end

        def show_slack
          data = config.fetch(:slack).merge(api_token: ENV["SLACK_API_TOKEN"]).to_a
          table.new(data).render(:unicode) do |r|
            r.border.separator = :each_row
          end
        end

        def show_additional_apps
          data = config.fetch(:additional_apps)
          table.new(header: %w[Name Enabled?], rows: data.map(&:values)).render(:unicode) do |r|
            r.border.separator = :each_row
            r.filter = ->(val, row_index, col_index) do
              col_index == 1 && val.strip == "true" ? pastel.black.on_bright_green(val) : val
            end
          end
        end
      end
    end
  end
end
