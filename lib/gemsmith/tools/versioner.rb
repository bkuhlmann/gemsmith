# frozen_string_literal: true

require "dry/monads"
require "milestoner"

module Gemsmith
  module Tools
    # Versions (tags) current project (local and remote).
    class Versioner
      include Dry::Monads[:result]

      def initialize client: Milestoner::Tags::Publisher.new,
                     content: Milestoner::Configuration::Content,
                     container: Container
        @client = client
        @content = content
        @container = container
      end

      def call specification
        client.call settings(specification)
        Success specification
      rescue Milestoner::Error => error
        Failure error.message
      end

      private

      attr_reader :client, :content, :container

      def settings specification
        content[
          documentation_format: configuration.extensions_milestoner_documentation_format,
          prefixes: configuration.extensions_milestoner_prefixes,
          sign: configuration.extensions_milestoner_sign,
          version: specification.version
        ]
      end

      def configuration = container[__method__]
    end
  end
end
