# frozen_string_literal: true

require "core"
require "optparse"

module Gemsmith
  module CLI
    # Assembles and parses all Command Line Interface (CLI) options.
    class Parser
      include Import[:configuration]

      CLIENT = OptionParser.new nil, 40, "  "

      # Order is important.
      SECTIONS = [Parsers::Core, Rubysmith::CLI::Parsers::Build, Parsers::Build].freeze

      def initialize(sections: SECTIONS, client: CLIENT, **)
        super(**)
        @sections = sections
        @client = client
        @configuration_duplicate = configuration.dup
      end

      def call arguments = Core::EMPTY_ARRAY
        sections.each { |section| section.call configuration_duplicate, client: }
        client.parse arguments
        configuration_duplicate.freeze
      end

      def to_s = client.to_s

      private

      attr_reader :sections, :client, :configuration_duplicate
    end
  end
end
