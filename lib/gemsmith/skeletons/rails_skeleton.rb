module Gemsmith
  module Skeletons
    class RailsSkeleton < BaseSkeleton
      def create_model_files
        template "#{model_root}/class_methods.rb.tt", template_options
        template "#{model_root}/instance_methods.rb.tt", template_options
      end

      def create_view_files
        template "#{lib_gem_root}/action_view/instance_methods.rb.tt", template_options
      end

      def create_controller_files
        template "#{controller_root}/class_methods.rb.tt", template_options
        template "#{controller_root}/instance_methods.rb.tt", template_options
      end

      def create_generator_files
        empty_directory "#{generator_root}/templates"
        template "#{generator_root}/install/install_generator.rb.tt", template_options
        template "#{generator_root}/install/USAGE.tt", template_options
        template "#{generator_root}/upgrade/upgrade_generator.rb.tt", template_options
        template "#{generator_root}/upgrade/USAGE.tt", template_options
      end

      def create_travis_gemfiles
        if template_options[:travis]
          template "%gem_name%/gemfiles/rails-4.1.x.gemfile.tt", template_options
        end
      end

      private

      def lib_gem_root
        "#{lib_root}/%gem_name%"
      end

      def model_root
        "#{lib_gem_root}/active_record"
      end

      def controller_root
        "#{lib_gem_root}/action_controller"
      end

      def generator_root
        "#{lib_root}/generators/%gem_name%"
      end
    end
  end
end
