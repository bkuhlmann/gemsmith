module Gemsmith
  module Skeletons
    class RailsSkeleton < BaseSkeleton
      def create_model_files
        template File.join("lib", "gem", "active_record", "class_methods.rb.tmp"), File.join(lib_install_path, gem_name, "active_record", "class_methods.rb"), template_options
        template File.join("lib", "gem", "active_record", "instance_methods.rb.tmp"), File.join(lib_install_path, gem_name, "active_record", "instance_methods.rb"), template_options
      end

      def create_view_files
        template File.join("lib", "gem", "action_view", "instance_methods.rb.tmp"), File.join(lib_install_path, gem_name, "action_view", "instance_methods.rb"), template_options
      end

      def create_controller_files
        template File.join("lib", "gem", "action_controller", "class_methods.rb.tmp"), File.join(lib_install_path, gem_name, "action_controller", "class_methods.rb"), template_options
        template File.join("lib", "gem", "action_controller", "instance_methods.rb.tmp"), File.join(lib_install_path, gem_name, "action_controller", "instance_methods.rb"), template_options
      end

      def create_generator_files
        empty_directory File.join(generators_install_path, "templates")
        template File.join(generators_source_path, "install", "install_generator.rb.tmp"), File.join(generators_install_path, "install", "install_generator.rb"), template_options
        template File.join(generators_source_path, "install", "USAGE.tmp"), File.join(generators_install_path, "install", "USAGE"), template_options
        template File.join(generators_source_path, "upgrade", "upgrade_generator.rb.tmp"), File.join(generators_install_path, "upgrade", "upgrade_generator.rb"), template_options
        template File.join(generators_source_path, "upgrade", "USAGE.tmp"), File.join(generators_install_path, "upgrade", "USAGE"), template_options
      end

      def create_travis_gemfiles
        if template_options[:travis]
          template File.join("gemfiles", "rails-3.2.x.gemfile.tmp"), File.join(install_path, "gemfiles", "rails-3.2.x.gemfile"), template_options
        end
      end

      private

      def generators_source_path
        File.join "lib", "generators", "gem"
      end

      def generators_install_path
        File.join lib_install_path, "generators", gem_name
      end
    end
  end
end
