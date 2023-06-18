# frozen_string_literal: true

require "refinements/structs"

module Gemsmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_rspec && configuration.build_cli

          builder.call(configuration.merge(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .touch
                 .replace("%r(^/spec/)", "%r((.+/container\\.rb|^/spec/))")
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
