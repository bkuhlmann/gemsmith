# frozen_string_literal: true

require "milestoner"
require "refinements/pathnames"
require "refinements/structs"
require "gemsmith/identity"
require "gemsmith/credentials"
require "gemsmith/cli"

module Gemsmith
  module Rake
    # Provides gem release functionality. Meant to be wrapped in Rake tasks.
    # :reek:TooManyInstanceVariables
    class Publisher
      using Refinements::Pathnames
      using Refinements::Structs

      def self.gem_spec_path
        Pathname.pwd.files("*.gemspec").first.to_s
      end

      # rubocop:disable Metrics/ParameterLists
      # :reek:LongParameterList
      def initialize gem_spec: Gemsmith::Gem::Specification.new(self.class.gem_spec_path.to_s),
                     gem_config: Gemsmith::CLI.configuration.to_h,
                     credentials: Gemsmith::Credentials,
                     publisher: Milestoner::Tags::Publisher.new,
                     milestoner_container: Milestoner::Container,
                     shell: Bundler::UI::Shell.new,
                     kernel: Kernel

        @gem_spec = gem_spec
        @gem_config = gem_config
        @credentials = credentials
        @publisher = publisher
        @milestoner_container = milestoner_container
        @shell = shell
        @kernel = kernel
      end
      # rubocop:enable Metrics/ParameterLists

      def push
        credentials.new(key: gem_spec.allowed_push_key.to_sym, url: gem_host)
                   .tap(&:create)
                   .then { |creds| %(--key "#{translate_key creds.key}" --host "#{gem_host}") }
                   .then { |options| execute_push options }
                   .then { |status| output_push status }
      end

      def publish
        milestoner_configuration.merge(git_tag_version: gem_spec.version, git_tag_sign: signed?)
                                .then { |configuration| publisher.call configuration }
        push
      rescue Milestoner::Error => error
        shell.error error.message
      end

      def signed?
        gem_config.dig :publish, :sign
      end

      private

      attr_reader :gem_spec,
                  :gem_config,
                  :credentials,
                  :publisher,
                  :milestoner_container,
                  :shell,
                  :kernel

      def gem_host
        gem_spec.allowed_push_host
      end

      def translate_key key
        key == credentials::DEFAULT_KEY ? :rubygems : key
      end

      def execute_push options
        kernel.system %(gem push "pkg/#{gem_spec.package_file_name}" #{options})
      end

      def output_push status
        package = gem_spec.package_file_name

        if status
          shell.confirm "Pushed #{package} to #{gem_host}."
        else
          shell.error "Failed pushing #{package} to #{gem_host}. " \
                      "Check gemspec and gem credential settings."
        end

        status
      end

      def milestoner_configuration = milestoner_container[:configuration]
    end
  end
end
