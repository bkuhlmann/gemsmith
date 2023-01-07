# frozen_string_literal: true

require "core"

module Gemsmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      include Actions::Import[
        :config,
        :build,
        :install,
        :publish,
        :edit,
        :view,
        :specification,
        :logger
      ]

      def initialize parser: Parser.new, **dependencies
        super(**dependencies)
        @parser = parser
      end

      def call arguments = Core::EMPTY_ARRAY
        perform parser.call(arguments)
      rescue OptionParser::ParseError => error
        logger.error { error.message }
      end

      private

      attr_reader :parser

      def perform configuration
        case configuration
          in action_config: Symbol => action then config.call action
          in action_build: true then build.call configuration
          in action_install: true then install.call configuration
          in action_publish: true then publish.call configuration
          in action_edit: String => gem_name then edit.call gem_name
          in action_view: String => gem_name then view.call gem_name
          in action_version: true then logger.info { specification.labeled_version }
          else logger.any { parser.to_s }
        end
      end
    end
  end
end
