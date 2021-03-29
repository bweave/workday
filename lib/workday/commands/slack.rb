# frozen_string_literal: true

require "erb"
require_relative "../command"

module Workday
  module Commands
    class Slack < Workday::Command
      def initialize(options)
        @options = options
        @client = slack_client
        @config = configurator.fetch(:slack)
      end

      def execute
        channel = options["channel"] || config["channel"] || prompt_for_channel
        message = options["message"] || prompt_for_message
        post_message(channel, message)
      end

      private

      attr_reader :options
      attr_reader :client
      attr_reader :config

      def prompt_for_channel
        channels = []
        spinner.run do
          client.conversations_list(exclude_archived: true, limit: 100, types: "public_channel,private_channel,mpim,im") do |resp|
            channels << resp.channels
          end
        end
        prompt.select("Channel:", channels, filter: true)
      end

      def prompt_for_message
        case prompt.select("Send a standup or regular message?", %w[Standup Normal])
        when "Standup"
          standup
        when "Normal"
          prompt.ask("What would you like to say?")
        else
          raise "Something has gone terribly wrong here."
        end
      end

      def standup
        yesterday = prompt.ask("What did you work on yesterday?")
        today = prompt.ask("What are you working on today?")
        mega = prompt.ask("Anything else?")
        ERB.new(<<~MSG.strip).result(binding)
          :thought_balloon: #{yesterday}
          :spiral_note_pad: #{today}
          <%= ":mega: #{mega}" if mega %>
        MSG
      end

      def post_message(channel, message)
        client.chat_postMessage(
          channel: channel,
          text: message,
          as_user: true,
          icon_url: config["icon_url"] || "",
        )
      end
    end
  end
end
