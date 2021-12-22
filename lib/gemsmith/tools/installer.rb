# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Installs a locally built gem.
    class Installer
      include Dry::Monads[:result, :do]

      # Order matters.
      STEPS = [Tools::Cleaner.new, Tools::Packager.new].freeze

      def initialize steps: STEPS, container: Container
        @steps = steps
        @container = container
      end

      def call specification
        steps.each { |step| yield step.call(specification) }
        run specification
      end

      private

      attr_reader :steps, :container

      def run specification
        path = specification.package_path

        executor.capture3("gem", "install", path.to_s).then do |_stdout, _stderr, status|
          status.success? ? Success(specification) : Failure("Unable to install: #{path}.")
        end
      end

      def executor = container[__method__]
    end
  end
end
