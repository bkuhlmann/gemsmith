# frozen_string_literal: true

require "milestoner"

module Gemsmith
  module Rake
    # Provides gem release functionality. Meant to be wrapped in Rake tasks.
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/ParameterLists
    class Release
      def self.default_gem_host
        Gem::DEFAULT_HOST
      end

      def initialize gem_spec_path = Dir.glob("#{Dir.pwd}/*.gemspec").first,
                     gem_config: Gem::ConfigFile.new([]),
                     bundler: Bundler,
                     publisher: Milestoner::Publisher.new,
                     shell: Bundler::UI::Shell.new,
                     kernel: Kernel

        @gem_spec_path = gem_spec_path
        @gem_config = gem_config
        @publisher = publisher
        @shell = shell
        @kernel = kernel
        @gem_spec = bundler.load_gemspec gem_spec_path.to_s
      rescue Errno::ENOENT
        @shell.error "Invalid gemspec file path: #{@gem_spec_path}."
      end

      def version_number
        gem_spec.version.version
      end

      def version_label
        "v#{version_number}"
      end

      def gem_file_name
        "#{gem_spec.name}-#{version_number}.gem"
      end

      def allowed_push_key
        gem_spec.metadata.fetch("allowed_push_key") { "rubygems_api_key" }
      end

      def allowed_push_host
        gem_spec.metadata.fetch("allowed_push_host") { self.class.default_gem_host }
      end

      def push
        return false unless gem_credentials? && gem_credential_value?

        kernel.system %(gem push "pkg/#{gem_file_name}" --key "#{allowed_push_key}" --host "#{allowed_push_host}")
        shell.confirm "Pushed #{gem_file_name} to #{allowed_push_host}."
        true
      end

      def publish sign: true
        publisher.publish version_number, sign: sign
        push
      rescue Milestoner::Errors::Base => error
        shell.error error.message
      end

      private

      attr_reader :gem_spec_path, :gem_config, :gem_spec, :publisher, :shell, :kernel

      def gem_credentials?
        return true if File.exist?(gem_config.credentials_path)
        shell.error "Unable to load gem credentials: #{gem_config.credentials_path}."
        false
      end

      def translated_api_key
        return :rubygems if allowed_push_key == "rubygems_api_key"
        allowed_push_key.to_sym
      end

      def gem_credential_value?
        value = gem_config.api_keys[translated_api_key]
        return true unless value.nil? || value.empty?

        shell.error %(Invalid credential (#{gem_config.credentials_path}): :#{allowed_push_key}: "#{value}".)
        false
      end
    end
  end
end
