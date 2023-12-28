# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console < Rubysmith::Builders::Console
      using Refinements::Struct

      def call
        return configuration unless configuration.build_console

        super
        builder.call(configuration.merge(template_path: "%project_name%/bin/console.erb"))
               .replace(/require Bundler.root.+/, %(require "#{configuration.project_path}"))

        configuration
      end
    end
  end
end
