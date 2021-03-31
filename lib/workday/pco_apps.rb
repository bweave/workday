# frozen_string_literal: true

require_relative "command"
require_relative "pco_box/locations"

module Workday
  module PcoApps
    APP_NAMES = %w[
      accounts
      api
      avatars
      check-ins
      church-center
      giving
      groups
      helpdesk
      login
      notifications
      people
      publishing
      push-gateway
      registrations
      resources
      services
      webhooks
    ].freeze

    def self.all
      location = PcoBox::Locations.from_config
      @all ||= APP_NAMES.map { |name| App.new(name, location) }
    end

    def self.before_update
      all.each(&:wip_it)
    end

    def self.after_update
      all.each(&:unwip_it)
    end

    class App < Workday::Command
      def initialize(name, location)
        @name = name
        @location = location
        @dir = "~/Code/#{name}"
        @should_unwip = false
      end

      def wip_it
        return if clean?

        @should_unwip = true
        prompt.say "⚙️  Gonna WIP #{name} - #{working_branch} branch is dirty", color: :on_bright_red
        cmd = [
          "cd #{dir}",
          "git add -A",
          "git commit --no-verify -m 'WIP'",
        ].join(";")
        location.run(cmd)
      end

      def unwip_it
        return unless should_unwip

        prompt.say "⚙️  UN-WIP-ing #{name}", color: :on_bright_green
        cmd = [
          "cd #{dir}",
          "git checkout #{working_branch}",
          "git log -n 1 | grep -q -c 'WIP' ; git reset HEAD~1",
        ].join(";")
        location.run(cmd)
      end

      private

      attr_reader :name
      attr_reader :location
      attr_reader :dir
      attr_reader :should_unwip

      def working_branch
        @working_branch ||= location.run("cd #{dir}; git symbolic-ref --short -q HEAD").out.strip
      end

      def git_status
        cmd = ["cd #{dir}", "git status --porcelain"].join(";")
        location.run(cmd).out
      end

      def clean?
        git_status.empty?
      end
    end
  end
end
