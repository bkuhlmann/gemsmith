module Gemsmith
  module Skeletons
    # Configures RSpec support.
    class RspecSkeleton < BaseSkeleton
      def create
        return unless configuration.create_rspec?

        cli.template "%gem_name%/lib/tasks/rspec.rake.tt", configuration.to_h
        cli.template "#{rspec_root}/spec_helper.rb.tt", configuration.to_h
        cli.template "#{rspec_root}/lib/%gem_name%/%gem_name%_spec.rb.tt", configuration.to_h
        cli.template "#{rspec_root}/support/kit/default_config.rb.tt", configuration.to_h
        cli.template "#{rspec_root}/support/kit/stderr.rb.tt", configuration.to_h
        cli.template "#{rspec_root}/support/kit/stdout.rb.tt", configuration.to_h
        cli.template "#{rspec_root}/support/kit/temp_dir.rb.tt", configuration.to_h
      end

      private

      def rspec_root
        "%gem_name%/spec"
      end
    end
  end
end
