# frozen_string_literal: true

require "dry/monads"
require "milestoner"

module Gemsmith
  module Tools
    # Versions (tags: local and remote) current project.
    class Versioner
      include Import[:configuration]
      include Dry::Monads[:result]

      def initialize(
        publisher: Milestoner::Tags::Publisher.new,
        model: Milestoner::Configuration::Model,
        **
      )
        super(**)
        @publisher = publisher
        @model = model
      end

      def call specification
        publisher.call settings(specification)
        Success specification
      rescue Milestoner::Error => error
        Failure error.message
      end

      private

      attr_reader :publisher, :model

      def settings specification
        model[
          documentation_format: configuration.extensions_milestoner_documentation_format,
          prefixes: configuration.extensions_milestoner_prefixes,
          version: specification.version
        ]
      end
    end
  end
end
