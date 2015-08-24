module Gemsmith
  module Skeletons
    class RailsSkeleton < BaseSkeleton
      def create_engine
        gem_name = template_options.fetch :gem_name
        system "rails plugin new #{gem_name} #{engine_options}"
        remove_file "#{gem_name}/MIT-LICENSE", template_options
        remove_file "#{gem_name}/README.rdoc", template_options
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

      def engine_options
        "--skip --skip-bundle --skip-test-unit --skip-keeps --skip-git --mountable --dummy-path=spec/dummy"
      end

      def lib_gem_root
        "#{lib_root}/%gem_name%"
      end

      def generator_root
        "#{lib_root}/generators/%gem_name%"
      end
    end
  end
end
