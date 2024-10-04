# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    module Git
      # Builds project skeleton Git ignore.
      class Ignore < Rubysmith::Builders::Git::Ignore
        using Refinements::Struct

        def call
          super

          return false unless settings.build_git

          builder.call(settings.merge(template_path: "%project_name%/.gitignore.erb"))
                 .touch
                 .prepend("*.gem\n")
                 .insert_before "tmp\n", <<~CONTENT
                   Gemfile.lock
                   pkg
                 CONTENT

          true
        end
      end
    end
  end
end
