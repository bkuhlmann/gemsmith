# frozen_string_literal: true

require "dry/monads"
require "rubygems/command_manager"

module Gemsmith
  module Tools
    # Pushes a gem package to remote gem server.
    class Pusher
      include Import[:executor, :logger]
      include Dry::Monads[:result]

      def initialize command: Gem::CommandManager.new, **dependencies
        super(**dependencies)

        @command = command
      end

      def call specification
        command.run ["push", specification.package_path.to_s, *one_time_password]
        Success specification
      rescue Gem::Exception => error
        Failure error.message
      end

      private

      attr_reader :command

      # :reek:TooManyStatements
      def one_time_password
        return [] if check_yubikey.failure?

        executor.capture3(check_yubikey.success, "oath", "accounts", "code", "--single", "RubyGems")
                .then { |stdout, _stderr, status| status.success? ? ["--otp", stdout.chomp] : [] }
      rescue Errno::ENOENT => error
        logger.warn { "Unable to obtain YubiKey One-Time Password. #{error}." }
        []
      end

      def check_yubikey
        executor.capture3("command", "-v", "ykman")
                .then do |stdout, stderr, status|
                  if status.success?
                    Success stdout.chomp
                  else
                    logger.warn { "Unable to find YubiKey Manager. #{stderr}." }
                    Failure()
                  end
                end
      end
    end
  end
end
