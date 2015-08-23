module Gemsmith
  module Skeletons
    class RspecSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/lib/%gem_name%/tasks/rspec.rake.tt", template_options
        template "#{rspec_root}/spec_helper.rb.tt", template_options
        template "#{rspec_root}/%gem_name%_spec.rb.tt", template_options
        template "#{rspec_root}/support/kit/default_config.rb.tt", template_options
        template "#{rspec_root}/support/kit/stderr.rb.tt", template_options
        template "#{rspec_root}/support/kit/stdout.rb.tt", template_options
        template "#{rspec_root}/support/kit/temp_dir.rb.tt", template_options
      end

      private

      def rspec_root
        "%gem_name%/spec"
      end
    end
  end
end
