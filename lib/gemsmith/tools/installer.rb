# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Installs a locally built gem.
    class Installer
      include Import[:executor]
      include Dry::Monads[:result, :do]

      # Order matters.
      STEPS = [Tools::Cleaner.new, Tools::Packager.new].freeze

      def initialize(steps: STEPS, **)
        super(**)
        @steps = steps
      end

      def call specification
        steps.each { |step| yield step.call(specification) }
        run specification
      end

      private

      attr_reader :steps

      def run specification
        path = specification.package_path

        executor.capture3("gem", "install", path.to_s).then do |_stdout, _stderr, status|
          status.success? ? Success(specification) : Failure("Unable to install: #{path}.")
        end
      end
    end
  end
end
