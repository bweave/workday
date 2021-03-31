# frozen_string_literal: true

require "json"
require_relative "../command"

module Workday
  class PcoBox < Workday::Command
    module Locations
      def location_from_config
        location = Workday::Command.new.configurator.fetch(:pco_box, :location)
        naively_titleized_location = location.to_s.gsub(/\b(?<!\w)[a-z]/) { |m| m.capitalize }
        self.class.const_get(naively_titleized_location)
      end

      class Local < Workday::Command
        def initialize(options)
          @options = options
        end

        def run(cmd)
          command.run!(cmd, pty: true)
        end

        private

        attr_reader :options
      end

      class Cloud < Workday::Command
        def initialize(options)
          @options = options
          # R&D-ed from https://github.com/ministrycentered/pco/blob/640b72c67698146f8072b5f87cc99ab638134622/libexec/pco-cloud9#L71
          data = JSON.parse(command.run("aws ec2 describe-instances --instance-ids='#{ENV["AWS_CLOUDBOX_EC2_INSTANCE_ID"]}' --region='#{ENV.fetch("AWS_CLOUDBOX_REGION", "us-east-1")}' --profile='planningcenter-dev'", only_output_on_error: true).out)
          @ip = data["Reservations"][0]["Instances"][0]["PublicIpAddress"]
        end

        def run(cmd)
          command.run!("#{reusable_ssh} ubuntu@#{ip} \"#{cmd}\"", pty: true)
        end

        private

        attr_reader :options
        attr_reader :ip

        def reusable_ssh
          # ControlPath=~/.ssh/main-pco-cloud-box sets up a control path for the ssh connection reuse
          # ControlMaster=auto allows the connection session to be shared using the ControlPath
          # ControlPesist=60 sets the amount of time the connection should remain open due to inactivity
          "ssh -t -o ControlPath=~/.ssh/main-pco-cloud-box -o ControlMaster=auto -o ControlPersist=60"
        end
      end
    end
  end
end
