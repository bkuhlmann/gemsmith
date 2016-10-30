# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures Ruby on Rails support.
    class RailsSkeleton < BaseSkeleton
      def rails?
        cli.run "command -v rails > /dev/null"
      end

      def install_rails
        return if rails?
        return unless cli.yes?("Ruby on Rails is not installed. Would you like to install it (y/n)?")
        cli.run "gem install rails"
      end

      def create_engine
        cli.template "#{lib_root}/%gem_path%/engine.rb.tt", configuration.to_h
        cli.run "rails plugin new --skip #{configuration.gem_name} #{engine_options}"
      end

      def create_generator_files
        cli.empty_directory "#{generator_root}/templates"
        cli.template "#{generator_root}/install/install_generator.rb.tt", configuration.to_h
        cli.template "#{generator_root}/install/USAGE.tt", configuration.to_h
        cli.template "#{generator_root}/upgrade/upgrade_generator.rb.tt", configuration.to_h
        cli.template "#{generator_root}/upgrade/USAGE.tt", configuration.to_h
      end

      def create_travis_gemfiles
        return unless configuration.create_travis?
        cli.template "%gem_name%/gemfiles/rails-%rails_version%.x.gemfile.tt", configuration.to_h
      end

      def remove_files
        gem_name = configuration.gem_name
        gem_path = configuration.gem_path

        cli.remove_file "#{gem_name}/app/helpers/#{gem_path}/application_helper.rb", configuration.to_h
        cli.remove_file "#{gem_name}/lib/#{gem_path}/version.rb", configuration.to_h
        cli.remove_file "#{gem_name}/MIT-LICENSE", configuration.to_h
        cli.remove_file "#{gem_name}/README.rdoc", configuration.to_h
      end

      def create
        return unless configuration.create_rails?

        install_rails
        create_engine
        create_generator_files
        create_travis_gemfiles
        remove_files
      end

      private

      def engine_options
        "--skip-bundle --skip-test --skip-keeps --skip-git --mountable --dummy-path=spec/dummy"
      end

      def generator_root
        "#{lib_root}/generators/%gem_path%"
      end
    end
  end
end
