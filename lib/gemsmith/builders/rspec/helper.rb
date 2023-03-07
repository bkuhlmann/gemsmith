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

          update_spec_helper
          render_shared_example
          configuration
        end

        private

        attr_reader :configuration, :builder

        def update_spec_helper
          builder.call(configuration.merge(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .touch
                 .insert_after(
                   %r(support/shared_contexts),
                   %(Pathname.require_tree SPEC_ROOT.join("support/shared_examples")\n)
                 )
        end

        def render_shared_example
          path = "%project_name%/spec/support/shared_examples/a_parser.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end
      end
    end
  end
end
