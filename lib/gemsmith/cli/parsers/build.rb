# frozen_string_literal: true

require "refinements/structs"

module Gemsmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) build options.
      class Build
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration = Container[:configuration],
                       client: Parser::CLIENT,
                       container: Container
          @configuration = configuration
          @client = client
          @container = container
        end

        def call arguments = []
          add_cli
          client.parse arguments
          configuration
        end

        private

        attr_reader :configuration, :client, :container

        def add_cli
          client.on(
            "--[no-]cli",
            "Add command line interface. #{default __method__}."
          ) do |value|
            configuration.merge! build_refinements: value, build_zeitwerk: value if value
            configuration.merge! build_cli: value
          end
        end

        def default option
          option.to_s
                .sub("add_", "build_")
                .then { |attribute| configuration.public_send attribute }
                .then { |boolean| boolean ? colorizer.green(boolean) : colorizer.red(boolean) }
                .then { |colored_boolean| "Default: #{colored_boolean}" }
        end

        def colorizer = container[__method__]
      end
    end
  end
end
