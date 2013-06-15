module Gemsmith
  module Skeletons
    class RailsSkeleton < BaseSkeleton
      def create_model_files
        template File.join(model_source_path, "class_methods.rb.tmp"), File.join(model_install_path, "class_methods.rb"), template_options
        template File.join(model_source_path, "instance_methods.rb.tmp"), File.join(model_install_path, "instance_methods.rb"), template_options
      end

      def create_view_files
        template File.join(gem_source_path, "action_view", "instance_methods.rb.tmp"), File.join(gem_install_path, "action_view", "instance_methods.rb"), template_options
      end

      def create_controller_files
        template File.join(controller_source_path, "class_methods.rb.tmp"), File.join(controller_install_path, "class_methods.rb"), template_options
        template File.join(controller_source_path, "instance_methods.rb.tmp"), File.join(controller_install_path, "instance_methods.rb"), template_options
      end

      def create_generator_files
        empty_directory File.join(generators_install_path, "templates")
        template File.join(install_generator_source_path, "install_generator.rb.tmp"), File.join(install_generator_install_path, "install_generator.rb"), template_options
        template File.join(install_generator_source_path, "USAGE.tmp"), File.join(install_generator_install_path, "USAGE"), template_options
        template File.join(upgrade_generator_source_path, "upgrade_generator.rb.tmp"), File.join(upgrade_generator_install_path, "upgrade_generator.rb"), template_options
        template File.join(upgrade_generator_source_path, "USAGE.tmp"), File.join(upgrade_generator_install_path, "USAGE"), template_options
      end

      def create_travis_gemfiles
        if template_options[:travis]
          template File.join("gemfiles", "rails-3.2.x.gemfile.tmp"), File.join(install_path, "gemfiles", "rails-3.2.x.gemfile"), template_options
        end
      end

      private

      def model_source_path
        File.join gem_source_path, "active_record"
      end

      def controller_source_path
        File.join gem_source_path, "action_controller"
      end

      def generators_source_path
        File.join "lib", "generators", "gem"
      end

      def install_generator_source_path
        File.join generators_source_path, "install"
      end

      def upgrade_generator_source_path
        File.join generators_source_path, "upgrade"
      end

      def model_install_path
        File.join gem_install_path, "active_record"
      end

      def controller_install_path
        File.join gem_install_path, "action_controller"
      end

      def generators_install_path
        File.join lib_install_path, "generators", gem_name
      end

      def install_generator_install_path
        File.join generators_install_path, "install"
      end

      def upgrade_generator_install_path
        File.join generators_install_path, "upgrade"
      end
    end
  end
end
