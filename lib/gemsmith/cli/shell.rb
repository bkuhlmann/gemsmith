# frozen_string_literal: true

require "core"

module Gemsmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      include Actions::Import[
        :build,
        :config,
        :edit,
        :install,
        :kernel,
        :logger,
        :publish,
        :specification,
        :view
      ]

      def initialize(parser: Parser.new, **)
        super(**)
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
          in action_build: true then build.call configuration
          in action_install: true then install.call configuration
          in action_publish: true then publish.call configuration
          in action_edit: String => gem_name then edit.call gem_name
          in action_view: String => gem_name then view.call gem_name
          in action_version: true then kernel.puts specification.labeled_version
          else kernel.puts parser.to_s
        end
      end
    end
  end
end
