require_relative "utils"

module OtherApps
  extend Utils

  def self.all
    @all ||= read_config["other_apps"].map { |attrs| App.new(attrs) }
  end

  def self.enabled
    all.select(&:enabled?)
  end

  def self.disabled
    all.select(&:disabled?)
  end

  def self.open
    all.each(&:open)
  end

  def self.close
    all.each(&:close)
  end

  class App
    attr_accessor :name
    attr_accessor :enabled
    alias enabled? enabled

    def initialize(attributes = {})
      attributes.each do |k, v|
        setter = :"#{k}="
        if respond_to?(setter)
          public_send(setter, v)
        else
          raise UnknownAttributeError.new(self, k.to_s)
        end
      end
    end

    def disabled?
      !enabled?
    end

    def open
      return if disabled?
      `osascript -e 'tell application "#{name}" to activate'`
    end

    def close
      return if disabled?
      `osascript -e 'tell application "#{name}" to quit'`
    end
  end
end
