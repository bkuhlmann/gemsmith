# frozen_string_literal: true

require "dry/monads"
require "milestoner"

module Gemsmith
  module Tools
    # Versions (tags) current project (local and remote).
    class Versioner
      include Import[:configuration]
      include Dry::Monads[:result]

      def initialize client: Milestoner::Tags::Publisher.new,
                     content: Milestoner::Configuration::Content,
                     **dependencies

        super(**dependencies)

        @client = client
        @content = content
      end

      def call specification
        client.call settings(specification)
        Success specification
      rescue Milestoner::Error => error
        Failure error.message
      end

      private

      attr_reader :client, :content

      def settings specification
        content[
          documentation_format: configuration.extensions_milestoner_documentation_format,
          prefixes: configuration.extensions_milestoner_prefixes,
          version: specification.version
        ]
      end
    end
  end
end
