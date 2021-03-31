# frozen_string_literal: true

require "thor"

module Workday
  module Commands
    class Config < Thor
      namespace :config

      desc "setup", "Setup configuration option"
      def setup
        if options[:help]
          invoke :help, ["setup"]
        else
          require_relative "config/setup"
          Workday::Commands::Config::Setup.new(options).execute
        end
      end

      desc "show", "Show your current configuration"
      def show
        if options[:help]
          invoke :help, ["show"]
        else
          require_relative "config/show"
          Workday::Commands::Config::Show.new(options).execute
        end
      end

      desc "add_app", "Add an application to start/end your day with"
      def add_app
        if options[:help]
          invoke :help, ["add_app"]
        else
          require_relative "config/add_app"
          Workday::Commands::Config::AddApp.new(options).execute
        end
      end
    end
  end
end
