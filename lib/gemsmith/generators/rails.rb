# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Ruby on Rails support.
    class Rails < Base
      def rails?
        cli.run "command -v rails > /dev/null"
      end

      def install_rails
        return if rails?
        return unless cli.yes?("Ruby on Rails is not installed. Would you like it installed (y/n)?")
        cli.run "gem install rails"
      end

      def create_engine
        cli.template "#{lib_root}/%gem_path%/engine.rb.tt", configuration
        cli.run "rails plugin new --skip #{configuration.dig :gem, :name} #{engine_options}"
      end

      # rubocop:disable Metrics/AbcSize
      def create_generator_files
        cli.empty_directory "#{generator_root}/templates"
        cli.template "#{generator_root}/install/install_generator.rb.tt", configuration
        cli.template "#{generator_root}/install/USAGE.tt", configuration
        cli.template "#{generator_root}/upgrade/upgrade_generator.rb.tt", configuration
        cli.template "#{generator_root}/upgrade/USAGE.tt", configuration
      end

      def create_travis_gemfiles
        return unless configuration.dig(:generate, :travis)
        cli.template "%gem_name%/gemfiles/rails-%rails_version%.x.gemfile.tt", configuration
      end

      def stub_assets
        cli.run %(printf "%s" > "#{gem_name}/app/assets/javascripts/#{gem_path}/application.js")
        cli.run %(printf "%s" > "#{gem_name}/app/assets/stylesheets/#{gem_path}/application.css")
      end

      def remove_files
        cli.remove_file "#{gem_name}/app/helpers/#{gem_path}/application_helper.rb", configuration
        cli.remove_file "#{gem_name}/lib/#{gem_path}/version.rb", configuration
        cli.remove_file "#{gem_name}/MIT-LICENSE", configuration
        cli.remove_file "#{gem_name}/README.rdoc", configuration
      end

      def run
        return unless configuration.dig(:generate, :rails)

        install_rails
        create_engine
        create_generator_files
        create_travis_gemfiles
        stub_assets
        remove_files
      end

      private

      def engine_options
        "--skip-bundle --skip-test --skip-keeps --skip-git --mountable --dummy-path=spec/dummy"
      end

      def generator_root
        "#{lib_root}/generators/%gem_path%"
      end

      def indentation
        "  " * (configuration.dig(:gem, :path).scan("/").size + 1)
      end
    end
  end
end
