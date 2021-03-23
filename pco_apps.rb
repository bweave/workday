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

  class App
    include Thor::Shell

    def initialize(name)
      @name = name
      @dir = "#{ENV.fetch("HOME")}/Code/#{name}"
      @working_branch = Dir.chdir(dir) { `git symbolic-ref --short -q HEAD`.strip }
      @should_unwip = false
    end

    def wip_it
      return if clean?

      @should_unwip = true
      say "⚙️  Gonna WIP #{name} - #{set_color(working_branch, :red)} branch is dirty"
      Dir.chdir(dir) { `git add -A && git commit --no-verify -m "WIP"` }
    end

    def unwip_it
      return unless should_unwip

      puts "⚙️  UN-WIP-ing #{name}"
      Dir.chdir(dir) do
        `git checkout #{working_branch}`
        `git log -n 1 | grep -q -c 'WIP' ; git reset HEAD~1`
      end
    end

    private

    attr_reader :name
    attr_reader :dir
    attr_reader :working_branch
    attr_reader :should_unwip

    def git_status
      Dir.chdir(dir) { `git status --porcelain` }
    end

    def clean?
      git_status.empty?
    end
  end
end
