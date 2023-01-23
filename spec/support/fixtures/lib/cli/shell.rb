require "core"

module Test
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      include Actions::Import[:config, :specification, :logger]

      def initialize parser: Parser.new, **dependencies
        super(**dependencies)
        @parser = parser
      end

      def call arguments = Core::EMPTY_ARRAY
        act_on parser.call(arguments)
      rescue OptionParser::ParseError => error
        logger.error { error.message }
      end

      private

      attr_reader :parser

      def act_on configuration
        case configuration
          in action_config: Symbol => action then config.call action
          in action_version: true then logger.info { specification.labeled_version }
          else logger.any { parser.to_s }
        end
      end
    end
  end
end
