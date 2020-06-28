# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates RSpec support.
    class Rspec < Base
      def run
        if configuration.dig :generate, :rspec
          install_templates
        else
          remove_rake_lines
        end
      end

      private

      def remove_rake_lines
        cli.gsub_file "#{gem_name}/Rakefile", /require.+rspec.+\n/, ""
        cli.gsub_file "#{gem_name}/Rakefile", /RSpec.+\n/, ""
      end

      def install_templates
        template "#{rspec_root}/spec_helper.rb.tt"
        install_rails_helper
        template "#{rspec_root}/support/shared_contexts/temp_dir.rb.tt"
      end

      def rspec_root
        "%gem_name%/spec"
      end

      def install_rails_helper
        return unless configuration.dig :generate, :engine

        template "#{rspec_root}/rails_helper.rb.tt"
      end
    end
  end
end
