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

      def add_comments
        file = "%gem_name%/app/controllers/%gem_path%/application_controller.rb"
        comment = "#{indentation}# The application controller.\n"
        cli.insert_into_file file, comment, before: /.+class.+/

        file = "%gem_name%/app/mailers/%gem_path%/application_mailer.rb"
        comment = "#{indentation}# The application mailer.\n"
        cli.insert_into_file file, comment, before: /.+class.+/

        file = "%gem_name%/app/models/%gem_path%/application_record.rb"
        comment = "#{indentation}# The application record.\n"
        cli.insert_into_file file, comment, before: /.+class.+/
      end

      def remove_files
        gem_path = configuration.dig :gem, :path

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
        add_comments
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
