# frozen_string_literal: true

require "refinements/structs"

module Gemsmith
  module Builders
    # Builds project skeleton CLI templates.
    class CLI
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return configuration unless configuration.build_cli

        render
        configuration
      end

      private

      attr_reader :configuration, :builder

      def render = private_methods.sort.grep(/render_/).each { |method| __send__ method }

      def render_exe
        builder.call(configuration.merge(template_path: "%project_name%/exe/%project_name%.erb"))
               .render
               .permit 0o755
      end

      def render_core
        content = configuration.merge template_path: "%project_name%/lib/%project_path%.rb.erb"

        builder.call(content)
               .insert_after(/push_dir/, %(  loader.inflector.inflect "cli" => "CLI"\n))
               .replace("Zeitwerk::Loader.for_gem.setup", <<~CONTENT.strip)
                 Zeitwerk::Loader.for_gem.then do |loader|
                   loader.inflector.inflect "cli" => "CLI"
                   loader.setup
                 end
               CONTENT
      end

      def render_configuration
        [
          "%project_name%/lib/%project_path%/configuration/content.rb.erb",
          "%project_name%/lib/%project_path%/configuration/defaults.yml.erb",
          "%project_name%/lib/%project_path%/configuration/loader.rb.erb",
          "%project_name%/lib/%project_path%/container.rb.erb",
          "%project_name%/lib/%project_path%/import.rb.erb"
        ].each { |path| builder.call(configuration.merge(template_path: path)).render }
      end

      def render_cli
        [
          "%project_name%/lib/%project_path%/cli/actions/config.rb.erb",
          "%project_name%/lib/%project_path%/cli/parser.rb.erb",
          "%project_name%/lib/%project_path%/cli/parsers/core.rb.erb",
          "%project_name%/lib/%project_path%/cli/shell.rb.erb"
        ].each { |path| builder.call(configuration.merge(template_path: path)).render }
      end

      def render_specs
        return unless configuration.build_rspec

        [
          "%project_name%/spec/lib/%project_path%/cli/actions/config_spec.rb.erb",
          "%project_name%/spec/lib/%project_path%/cli/parser_spec.rb.erb",
          "%project_name%/spec/lib/%project_path%/cli/parsers/core_spec.rb.erb",
          "%project_name%/spec/lib/%project_path%/cli/shell_spec.rb.erb",
          "%project_name%/spec/lib/%project_path%/configuration/content_spec.rb.erb",
          "%project_name%/spec/lib/%project_path%/configuration/loader_spec.rb.erb"
        ].each { |path| builder.call(configuration.merge(template_path: path)).render }
      end

      def render_rspec_support
        return unless configuration.build_rspec

        [
          "%project_name%/spec/support/shared_contexts/application_container.rb.erb",
          "%project_name%/spec/support/shared_examples/a_parser.rb.erb"
        ].each { |path| builder.call(configuration.merge(template_path: path)).render }
      end
    end
  end
end
