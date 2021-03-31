# frozen_string_literal: true

require_relative "../../command"

module Workday
  module Commands
    class Config
      class AddApp < Workday::Command
        def initialize(options)
          @options = options
          @config = configurator
        end

        def execute
          name = prompt.ask "App name:"
          enabled = prompt.yes? "Enable it?"
          config.append({name: name, enabled: enabled}, to: :additional_apps)
          config.write force: true
          prompt.ok "✅ #{name} added."
        end

        private

        attr_reader :options
        attr_reader :config
      end
    end
  end
end
