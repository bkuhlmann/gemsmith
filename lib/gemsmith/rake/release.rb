# frozen_string_literal: true

require "milestoner"

module Gemsmith
  module Rake
    # Provides gem release functionality. Meant to be wrapped in Rake tasks.
    class Release
      def initialize gem_spec: Gemsmith::Wrappers::GemSpec.new(Dir.glob("#{Dir.pwd}/*.gemspec").first),
                     gem_config: Gem::ConfigFile.new([]),
                     publisher: Milestoner::Publisher.new,
                     shell: Bundler::UI::Shell.new,
                     kernel: Kernel

        @gem_spec = gem_spec
        @gem_config = gem_config
        @publisher = publisher
        @shell = shell
        @kernel = kernel
      end

      def push
        return false unless gem_credentials? && gem_credential_value?

        options = %(--key "#{translated_api_key}" --host "#{gem_spec.allowed_push_host}")
        kernel.system %(gem push "pkg/#{gem_spec.package_file_name}" #{options})
        shell.confirm "Pushed #{gem_spec.package_file_name} to #{gem_spec.allowed_push_host}."
        true
      end

      def publish sign: true
        publisher.publish gem_spec.version_number, sign: sign
        push
      rescue Milestoner::Errors::Base => error
        shell.error error.message
      end

      private

      attr_reader :gem_spec, :gem_config, :publisher, :shell, :kernel

      def gem_credentials?
        return true if File.exist?(gem_config.credentials_path)
        shell.error "Unable to load gem credentials: #{gem_config.credentials_path}."
        false
      end

      def gem_credential_value?
        value = gem_config.api_keys[translated_api_key]
        return true unless value.nil? || value.empty?

        shell.error %(Invalid credential (#{gem_config.credentials_path}): :#{gem_spec.allowed_push_key}: "#{value}".)
        false
      end

      def translated_api_key
        return :rubygems if gem_spec.allowed_push_key == "rubygems_api_key"
        gem_spec.allowed_push_key.to_sym
      end
    end
  end
end
