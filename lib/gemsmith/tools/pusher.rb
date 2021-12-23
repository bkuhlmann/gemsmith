# frozen_string_literal: true

require "dry/monads"
require "rubygems/command_manager"

module Gemsmith
  module Tools
    # Pushes a gem package to remote gem server.
    class Pusher
      include Dry::Monads[:result]

      def initialize command: Gem::CommandManager.new, container: Container
        @command = command
        @container = container
      end

      def call specification
        command.run ["push", specification.package_path.to_s, *one_time_password]
        Success specification
      rescue Gem::Exception => error
        Failure error.message
      end

      private

      attr_reader :command, :container

      def one_time_password
        executor.capture3("ykman", "oath", "accounts", "code", "--single", "RubyGems")
                .then { |stdout, _stderr, status| status.success? ? ["--otp", stdout.chomp] : [] }
      end

      def executor = container[__method__]
    end
  end
end
