# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates RSpec support.
    class Rspec < Base
      def run
        return unless configuration.dig(:generate, :rspec)

        uncomment_lines
        install_templates
      end

      private

      def rspec_root
        "%gem_name%/spec"
      end

      def uncomment_lines
        cli.uncomment_lines "#{gem_name}/Rakefile", /require.+rspec.+/
        cli.uncomment_lines "#{gem_name}/Rakefile", /RSpec.+/
      end

      def install_templates
        template "#{rspec_root}/spec_helper.rb.tt"
        install_rails_helper
        template "#{rspec_root}/support/shared_contexts/temp_dir.rb.tt"
      end

      def install_rails_helper
        return unless configuration.dig(:generate, :engine)
        template "#{rspec_root}/rails_helper.rb.tt"
      end
    end
  end
end
