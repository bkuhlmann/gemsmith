module Gemsmith
  module Skeletons
    class RspecSkeleton < BaseSkeleton
      def create_files
        template "rspec.tmp", File.join(install_path, ".rspec"), template_options
        template File.join("spec", "spec_helper.rb.tmp"), File.join(rspec_install_path, "spec_helper.rb"), template_options
        template File.join("spec", "gem_spec.rb.tmp"), File.join(rspec_install_path, "#{gem_name}_spec.rb"), template_options
      end

      private

      def rspec_install_path
        File.join install_path, "spec"
      end
    end
  end
end
