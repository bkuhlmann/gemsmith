# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton CLI templates.
    class CLI
      using Refinements::Struct

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
               .insert_before(/tag/, %(  loader.inflector.inflect "cli" => "CLI"\n))
      end

      def render_configuration
        [
          "%project_name%/lib/%project_path%/configuration/contract.rb.erb",
          "%project_name%/lib/%project_path%/configuration/model.rb.erb",
          "%project_name%/lib/%project_path%/configuration/defaults.yml.erb",
          "%project_name%/lib/%project_path%/container.rb.erb",
          "%project_name%/lib/%project_path%/import.rb.erb"
        ].each { |path| builder.call(configuration.merge(template_path: path)).render }
      end

      def render_shell
        path = "%project_name%/lib/%project_path%/cli/shell.rb.erb"
        builder.call(configuration.merge(template_path: path)).render
      end

      def render_specs
        return unless configuration.build_rspec

        [
          "%project_name%/spec/lib/%project_path%/cli/shell_spec.rb.erb",
          "%project_name%/spec/support/shared_contexts/application_dependencies.rb.erb"
        ].each { |path| builder.call(configuration.merge(template_path: path)).render }
      end
    end
  end
end
