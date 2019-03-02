# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Ruby on Rails Engine support.
    class Engine < Base
      def rails?
        cli.run "command -v rails > /dev/null"
      end

      def install_rails
        return if rails?
        return unless cli.yes? "Ruby on Rails is not installed. Would you like it installed (y/n)?"

        cli.run "gem install rails"
      end

      def create_engine
        template "#{LIB_ROOT}/%gem_path%/engine.rb.tt"
        cli.run "rails plugin new --skip #{configuration.dig :gem, :name} #{engine_options}"
      end

      def create_generator_files
        cli.empty_directory "#{generator_root}/templates"
        template "#{generator_root}/install/install_generator.rb.tt"
        template "#{generator_root}/install/USAGE.tt"
        template "#{generator_root}/upgrade/upgrade_generator.rb.tt"
        template "#{generator_root}/upgrade/USAGE.tt"
      end

      def stub_assets
        cli.run %(printf "%s" > "#{gem_name}/app/assets/javascripts/#{gem_path}/application.js")
        cli.run %(printf "%s" > "#{gem_name}/app/assets/stylesheets/#{gem_path}/application.css")
      end

      # rubocop:disable Metrics/AbcSize
      def remove_files
        cli.remove_file "#{gem_name}/app/helpers/#{gem_path}/application_helper.rb", configuration
        cli.remove_file "#{gem_name}/lib/#{gem_path}/version.rb", configuration
        cli.remove_file "#{gem_name}/MIT-LICENSE", configuration
        cli.remove_file "#{gem_name}/README.rdoc", configuration
      end
      # rubocop:enable Metrics/AbcSize

      # :reek:TooManyStatements
      def run
        return unless runnable?

        install_rails
        create_engine
        create_generator_files
        stub_assets
        remove_files
      end

      private

      def runnable?
        configuration.dig :generate, :engine
      end

      def engine_options
        "--skip-git " \
        "--skip-bundle " \
        "--skip-keeps " \
        "--skip-turbolinks " \
        "--skip-spring " \
        "--skip-test " \
        "--mountable " \
        "--dummy-path=spec/dummy"
      end

      def generator_root
        "#{LIB_ROOT}/generators/%gem_path%"
      end

      def indentation
        "  " * (configuration.dig(:gem, :path).scan("/").size + 1)
      end
    end
  end
end
