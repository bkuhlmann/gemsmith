# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console < Rubysmith::Builders::Console
      using Refinements::Struct

      def call
        return false unless settings.build_console

        super
        builder.call(settings.merge(template_path: "%project_name%/bin/console.erb"))
               .replace(/require Bundler.root.+/, %(require "#{settings.project_path}"))

        true
      end
    end
  end
end
