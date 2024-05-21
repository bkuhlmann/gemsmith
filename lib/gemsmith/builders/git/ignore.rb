# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    module Git
      # Builds project skeleton Git ignore.
      class Ignore < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_git

          builder.call(configuration.merge(template_path: "%project_name%/.gitignore.erb"))
                 .touch
                 .prepend("*.gem\n")
                 .insert_before "tmp\n", <<~CONTENT
                   Gemfile.lock
                   pkg
                 CONTENT

          configuration
        end
      end
    end
  end
end
