# frozen_string_literal: true

require_relative "lib/workday/version"

Gem::Specification.new do |spec|
  spec.name = "workday"
  spec.version = Workday::VERSION
  spec.summary = "Start and end your Planning Center work day with this handy CLI tool."
  spec.description = <<~DESC
    Start and end your Planning Center work day with this handy CLI tool.
  DESC
  spec.authors = ["Brian Weaver"]
  spec.license = "MIT"
  spec.email = "brian@planningcenter.com"
  spec.homepage = "https://github.com/bweave/workday"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bweave/workday/issues",
    "changelog_uri" => "https://github.com/bweave/workday/blob/master/CHANGELOG.md",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
  }

  spec.files = Dir["lib/**/*"]
  spec.bindir = "exe"
  spec.executables = %w[workday]

  spec.required_ruby_version = ">= 2.7"

  spec.add_dependency "pastel", "~> 0.8.0"
  spec.add_dependency "slack-ruby-client", "~>0.17"
  spec.add_dependency "thor", "~>1.1"
  spec.add_dependency "tty-command", "~> 0.10.0"
  spec.add_dependency "tty-config", "~> 0.4.0"
  spec.add_dependency "tty-prompt", "~> 0.23.0"
  spec.add_dependency "tty-pager", "~> 0.14.0"
  spec.add_dependency "tty-spinner", "~> 0.9.0"
  spec.add_dependency "tty-table", "~> 0.12.0"
end
