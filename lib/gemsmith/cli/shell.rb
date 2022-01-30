# frozen_string_literal: true

module Gemsmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      ACTIONS = {
        config: Actions::Config.new,
        build: Actions::Build.new,
        install: Actions::Install.new,
        publish: Actions::Publish.new,
        edit: Actions::Edit.new,
        view: Actions::View.new
      }.freeze

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
          in action_build: true then build configuration
          in action_install: true then install configuration
          in action_publish: true then publish configuration
          in action_edit: String => gem_name then edit gem_name
          in action_view: String => gem_name then view gem_name
          in action_version: true then logger.info { specification.labeled_version }
          else usage
        end
      end

      def config(action) = actions.fetch(__method__).call(action)

      def build(configuration) = actions.fetch(__method__).call(configuration)

      def install(configuration) = actions.fetch(__method__).call(configuration)

      def publish(configuration) = actions.fetch(__method__).call(configuration)

      def edit(gem_name) = actions.fetch(__method__).call(gem_name)

      def view(gem_name) = actions.fetch(__method__).call(gem_name)

      def usage = logger.unknown { parser.to_s }

      def logger = container[__method__]

      def specification = container[__method__]

      def process = container[__method__]
    end
  end
end
