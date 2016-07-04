# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures RSpec support.
    class RspecSkeleton < BaseSkeleton
      def create
        return unless configuration.create_rspec?

        cli.template "%gem_name%/lib/tasks/rspec.rake.tt", configuration.to_h
        cli.template("#{rspec_root}/rails_helper.rb.tt", configuration.to_h) if configuration.create_rails?
        cli.template "#{rspec_root}/spec_helper.rb.tt", configuration.to_h
        cli.template "#{rspec_root}/lib/%gem_name%/%gem_name%_spec.rb.tt", configuration.to_h
        cli.template "#{rspec_root}/support/shared_contexts/temp_dir.rb.tt", configuration.to_h
      end

      private

      def rspec_root
        "%gem_name%/spec"
      end
    end
  end
end
