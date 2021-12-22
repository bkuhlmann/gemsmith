# frozen_string_literal: true

require "dry/monads"
require "refinements/pathnames"
require "rubygems/command_manager"

module Gemsmith
  module Tools
    # Builds a gem package for distribution.
    class Packager
      include Dry::Monads[:result]

      using Refinements::Pathnames

      def initialize command: Gem::CommandManager.new
        @command = command
      end

      # :reek:TooManyStatements
      def call specification
        command.run ["build", "#{specification.name}.gemspec"]
        specification.package_path.then { |path| path.make_ancestors.basename.copy path.parent }
        Success specification
      rescue Gem::Exception => error
        Failure error.message
      end

      private

      attr_reader :command
    end
  end
end
