module Gemsmith
  module Skeletons
    class RailsSkeleton < BaseSkeleton
      def create_action_controller_files
        template File.join("lib", "gem", "action_controller", "class_methods.rb.tmp"), File.join(install_path, "lib", gem_name, "action_controller", "class_methods.rb"), template_options
        template File.join("lib", "gem", "action_controller", "instance_methods.rb.tmp"), File.join(install_path, "lib", gem_name, "action_controller", "instance_methods.rb"), template_options
      end

      def create_action_view_files
        template File.join("lib", "gem", "action_view", "instance_methods.rb.tmp"), File.join(install_path, "lib", gem_name, "action_view", "instance_methods.rb"), template_options
      end

      def create_active_record_files
        template File.join("lib", "gem", "active_record", "class_methods.rb.tmp"), File.join(install_path, "lib", gem_name, "active_record", "class_methods.rb"), template_options
        template File.join("lib", "gem", "active_record", "instance_methods.rb.tmp"), File.join(install_path, "lib", gem_name, "active_record", "instance_methods.rb"), template_options
      end

      def create_generator_files
        empty_directory File.join(install_path, "lib", "generators", gem_name, "templates")
        template File.join("lib", "generators", "gem", "install", "install_generator.rb.tmp"), File.join(install_path, "lib", "generators", gem_name, "install", "install_generator.rb"), template_options
        template File.join("lib", "generators", "gem", "install", "USAGE.tmp"), File.join(install_path, "lib", "generators", gem_name, "install", "USAGE"), template_options
        template File.join("lib", "generators", "gem", "upgrade", "upgrade_generator.rb.tmp"), File.join(install_path, "lib", "generators", gem_name, "upgrade", "upgrade_generator.rb"), template_options
        template File.join("lib", "generators", "gem", "upgrade", "USAGE.tmp"), File.join(install_path, "lib", "generators", gem_name, "upgrade", "USAGE"), template_options
      end

      def create_travis_gemfiles
        if template_options[:travis]
          template File.join("gemfiles", "rails-3.2.x.gemfile.tmp"), File.join(install_path, "gemfiles", "rails-3.2.x.gemfile"), template_options
        end
      end
    end
  end
end
