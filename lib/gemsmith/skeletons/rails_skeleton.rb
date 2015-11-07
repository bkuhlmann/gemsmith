module Gemsmith
  module Skeletons
    # Configures Ruby on Rails support.
    class RailsSkeleton < BaseSkeleton
      def enabled?
        cli.template_options.key?(:rails) && cli.template_options[:rails]
      end

      def rails?
        cli.run "command -v rails > /dev/null"
      end

      def install_rails
        return if rails?
        return unless cli.yes?("Ruby on Rails is not installed. Would you like to install it (y/n)?")
        cli.run "gem install rails"
      end

      def create_engine
        gem_name = cli.template_options.fetch :gem_name

        cli.template "#{lib_root}/%gem_name%/engine.rb.tt", cli.template_options
        cli.run "rails plugin new --skip #{gem_name} #{engine_options}"
        cli.remove_file "#{gem_name}/app/helpers/#{gem_name}/application_helper.rb", cli.template_options
        cli.remove_file "#{gem_name}/lib/#{gem_name}/version.rb", cli.template_options
        cli.remove_file "#{gem_name}/MIT-LICENSE", cli.template_options
        cli.remove_file "#{gem_name}/README.rdoc", cli.template_options
      end

      def create_generator_files
        cli.empty_directory "#{generator_root}/templates"
        cli.template "#{generator_root}/install/install_generator.rb.tt", cli.template_options
        cli.template "#{generator_root}/install/USAGE.tt", cli.template_options
        cli.template "#{generator_root}/upgrade/upgrade_generator.rb.tt", cli.template_options
        cli.template "#{generator_root}/upgrade/USAGE.tt", cli.template_options
      end

      def create_travis_gemfiles
        return unless cli.template_options[:travis]
        cli.template "%gem_name%/gemfiles/rails-4.1.x.gemfile.tt", cli.template_options
      end

      def create
        return unless enabled?

        install_rails
        create_engine
        create_generator_files
        create_travis_gemfiles
      end

      private

      def engine_options
        "--skip-bundle --skip-test-unit --skip-keeps --skip-git --mountable --dummy-path=spec/dummy"
      end

      def generator_root
        "#{lib_root}/generators/%gem_name%"
      end
    end
  end
end
