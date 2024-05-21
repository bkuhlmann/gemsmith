# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_rspec && configuration.build_cli

          builder.call(configuration.merge(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .touch
                 .replace("%r(^/spec/)", "%r((.+/container\\.rb|^/spec/))")
          configuration
        end
      end
    end
  end
end
