# frozen_string_literal: true

module Gemsmith
  module Generators
    # Configures RSpec support.
    class Rspec < Base
      def create
        return unless configuration.dig(:generate, :rspec)

        cli.template "%gem_name%/lib/tasks/rspec.rake.tt", configuration
        cli.template "#{rspec_root}/spec_helper.rb.tt", configuration
        cli.template("#{rspec_root}/rails_helper.rb.tt", configuration) if configuration.dig(:generate, :rails)
        cli.template "#{rspec_root}/support/shared_contexts/temp_dir.rb.tt", configuration
      end

      private

      def rspec_root
        "%gem_name%/spec"
      end
    end
  end
end
