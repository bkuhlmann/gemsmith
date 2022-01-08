# frozen_string_literal: true

require "dry/monads"

module Gemsmith
  module Tools
    # Handles the publication of a gem version.
    class Publisher
      include Dry::Monads[:result, :do]

      # Order matters.
      STEPS = [
        Tools::Cleaner.new,
        Tools::Validator.new,
        Tools::Packager.new,
        Tools::Versioner.new,
        Tools::Pusher.new
      ].freeze

      def initialize steps: STEPS
        @steps = steps
      end

      def call specification
        steps.each { |step| yield step.call(specification) }
        Success specification
      end

      private

      attr_reader :steps
    end
  end
end
