module Gemsmith
  module Skeletons
    class RspecSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/.rspec.tt", template_options
        template "#{rspec_root}/spec_helper.rb.tt", template_options
        template "#{rspec_root}/%gem_name%_spec.rb.tt", template_options
      end

      private

      def rspec_root
        "%gem_name%/spec"
      end
    end
  end
end
