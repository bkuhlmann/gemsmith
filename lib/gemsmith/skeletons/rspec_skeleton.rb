module Gemsmith
  module Skeletons
    class RspecSkeleton < BaseSkeleton
      def create_files
        template "rspec.tmp", File.join(install_path, ".rspec"), template_options
        template File.join("spec", "spec_helper.rb.tmp"), File.join(install_path, "spec", "spec_helper.rb"), template_options
        template File.join("spec", "gem_spec.rb.tmp"), File.join(install_path, "spec", "#{gem_name}_spec.rb"), template_options
      end
    end
  end
end
