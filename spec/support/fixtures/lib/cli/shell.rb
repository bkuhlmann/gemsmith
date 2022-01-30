module Test
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      ACTIONS = {config: Actions::Config.new}.freeze

      def initialize parser: Parser.new, actions: ACTIONS, container: Container
        @parser = parser
        @actions = actions
        @container = container
      end

      def call arguments = []
        perform parser.call(arguments)
      rescue OptionParser::ParseError => error
        logger.error { error.message }
      end

      private

      attr_reader :parser, :actions, :container

      def perform configuration
        case configuration
          in action_config: Symbol => action then config action
          in action_version: true then logger.info { "Test 0.0.0" }
          else usage
        end
      end

      def config(action) = actions.fetch(__method__).call(action)

      def usage = logger.unknown { parser.to_s }

      def logger = container[__method__]
    end
  end
end
