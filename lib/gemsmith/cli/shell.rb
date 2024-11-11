# frozen_string_literal: true

require "sod"

module Gemsmith
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      include Dependencies[:defaults_path, :xdg_config, :specification]

      def initialize(context: Sod::Context, dsl: Sod, **)
        super(**)
        @context = context
        @dsl = dsl
      end

      def call(...) = cli.call(...)

      private

      attr_reader :context, :dsl

      def cli
        context = build_context

        dsl.new :gemsmith, banner: specification.banner do
          on(Sod::Prefabs::Commands::Config, context:)
          on Commands::Build
          on Actions::Install
          on Actions::Publish
          on Actions::Edit
          on Actions::View
          on(Sod::Prefabs::Actions::Version, context:)
          on Sod::Prefabs::Actions::Help, self
        end
      end

      def build_context
        context[defaults_path:, xdg_config:, version_label: specification.labeled_version]
      end
    end
  end
end
