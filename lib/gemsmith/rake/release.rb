# frozen_string_literal: true

require "milestoner"
require "gemsmith/credentials"

module Gemsmith
  module Rake
    # Provides gem release functionality. Meant to be wrapped in Rake tasks.
    class Release
      def self.gem_spec_path
        String Dir["#{Dir.pwd}/*.gemspec"].first
      end

      def initialize gem_spec: Gemsmith::Gem::Specification.new(self.class.gem_spec_path),
                     credentials: Gemsmith::Credentials,
                     publisher: Milestoner::Publisher.new,
                     shell: Bundler::UI::Shell.new,
                     kernel: Kernel

        @gem_spec = gem_spec
        @credentials = credentials
        @publisher = publisher
        @shell = shell
        @kernel = kernel
      end

      def push
        creds = credentials.new key: gem_spec.allowed_push_key.to_sym, url: gem_spec.allowed_push_host
        creds.create

        options = %(--key "#{translate_key creds.key}" --host "#{gem_spec.allowed_push_host}")
        status = kernel.system %(gem push "pkg/#{gem_spec.package_file_name}" #{options})
        process_push status
      end

      def publish sign: true
        publisher.publish gem_spec.version_number, sign: sign
        push
      rescue Milestoner::Errors::Base => error
        shell.error error.message
      end

      private

      attr_reader :gem_spec, :credentials, :publisher, :shell, :kernel

      def translate_key key
        key == credentials.default_key ? :rubygems : key
      end

      def process_push status
        if status
          shell.confirm "Pushed #{gem_spec.package_file_name} to #{gem_spec.allowed_push_host}."
        else
          shell.error "Failed pushing #{gem_spec.package_file_name} to #{gem_spec.allowed_push_host}. " \
                      "Check gemspec and gem credential settings."
        end

        status
      end
    end
  end
end
