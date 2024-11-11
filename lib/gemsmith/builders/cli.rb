# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton CLI templates.
    class CLI < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        return false unless settings.build_cli

        render
        true
      end

      private

      def render = private_methods.sort.grep(/render_/).each { |method| __send__ method }

      def render_exe
        builder.call(settings.merge(template_path: "%project_name%/exe/%project_name%.erb"))
               .render
               .permit 0o755
      end

      def render_core
        content = settings.merge template_path: "%project_name%/lib/%project_path%.rb.erb"

        builder.call(content)
               .insert_before(/tag/, %(  loader.inflector.inflect "cli" => "CLI"\n))
      end

      def render_configuration
        [
          "%project_name%/lib/%project_path%/configuration/contract.rb.erb",
          "%project_name%/lib/%project_path%/configuration/model.rb.erb",
          "%project_name%/lib/%project_path%/configuration/defaults.yml.erb",
          "%project_name%/lib/%project_path%/container.rb.erb",
          "%project_name%/lib/%project_path%/dependencies.rb.erb"
        ].each { |path| builder.call(settings.merge(template_path: path)).render }
      end

      def render_shell
        path = "%project_name%/lib/%project_path%/cli/shell.rb.erb"
        builder.call(settings.merge(template_path: path)).render
      end

      def render_requirements
        return if settings.build_zeitwerk

        builder.call(settings.merge(template_path: "%project_name%/lib/%project_path%.rb.erb"))
               .render
               .prepend <<~CONTENT
                 require "demo/configuration/contract"
                 require "demo/configuration/model"
                 require "demo/container"
                 require "demo/dependencies"

                 require "demo/cli/shell"

                 # Main namespace.
               CONTENT
      end

      def render_specs
        return unless settings.build_rspec

        [
          "%project_name%/spec/lib/%project_path%/cli/shell_spec.rb.erb",
          "%project_name%/spec/support/shared_contexts/application_dependencies.rb.erb"
        ].each { |path| builder.call(settings.merge(template_path: path)).render }
      end
    end
  end
end
