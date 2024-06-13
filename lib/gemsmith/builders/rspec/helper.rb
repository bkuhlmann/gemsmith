# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper < Rubysmith::Builders::RSpec::Helper
        using Refinements::Struct

        def call
          return false unless settings.build_rspec && settings.build_cli

          super
          builder.call(settings.merge(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .replace("%r(^/spec/)", "%r((.+/container\\.rb|^/spec/))")

          true
        end
      end
    end
  end
end
