# frozen_string_literal: true

require "dry/monads"
require "milestoner"

module Gemsmith
  module Tools
    # Versions (tags: local and remote) current project.
    class Versioner
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

      def call(specification) = publisher.call(specification.version).fmap { specification }

      private

      attr_reader :publisher, :model
    end
  end
end
