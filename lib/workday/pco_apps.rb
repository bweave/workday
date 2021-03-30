# frozen_string_literal: true

require_relative "command"

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
      @all ||= APP_NAMES.map { |name| App.new(name) }
    end

    def self.before_update
      all.each(&:wip_it)
    end

    def self.after_update
      all.each(&:unwip_it)
    end

    class App < Workday::Command
      def initialize(name)
        @name = name
        @dir = "#{ENV.fetch("HOME")}/Code/#{name}"
        @working_branch = command.run("git symbolic-ref --short -q HEAD", chdir: dir).out.strip
        @should_unwip = false
      end

      def wip_it
        return if clean?

        @should_unwip = true
        prompt.say "⚙️  Gonna WIP #{name} - #{working_branch} branch is dirty", color: :on_bright_red
        command.run "git add -A && git commit --no-verify -m 'WIP'", chdir: dir
      end

      def unwip_it
        return unless should_unwip

        prompt.say "⚙️  UN-WIP-ing #{name}", color: :on_bright_green
        Dir.chdir(dir) do
          command.run "git checkout #{working_branch}"
          command.run "git log -n 1 | grep -q -c 'WIP' ; git reset HEAD~1"
        end
      end

      private

      attr_reader :name
      attr_reader :dir
      attr_reader :working_branch
      attr_reader :should_unwip

      def git_status
        command.run("git status --porcelain", chdir: dir).out
      end

      def clean?
        git_status.empty?
      end
    end
  end
end
