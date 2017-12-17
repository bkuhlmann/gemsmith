# frozen_string_literal: true

require "yaml"
require "fileutils"
require "gemsmith/authenticators/basic"
require "gemsmith/authenticators/ruby_gems"

module Gemsmith
  # Generates gem credentials for RubyGems and/or alternative servers.
  class Credentials
    attr_reader :key, :url

    def self.default_key
      :rubygems_api_key
    end

    def self.default_url
      "https://rubygems.org"
    end

    def self.file_path
      File.join ENV.fetch("HOME"), ".gem", "credentials"
    end

    def self.authenticators
      [Authenticators::RubyGems, Authenticators::Basic]
    end

    # :reek:DuplicateMethodCall
    def initialize key: self.class.default_key,
                   url: self.class.default_url,
                   shell: Thor::Shell::Basic.new
      @key = key
      @url = url
      @shell = shell
      @credentials = load_credentials
    end

    def authenticator
      selected = self.class.authenticators.find { |auth| auth.url.include? url }
      selected ? selected : Authenticators::Basic
    end

    def value
      String credentials[key]
    end

    def valid?
      credentials? && !String(credentials[key]).empty?
    end

    # rubocop:disable Metrics/AbcSize
    # :reek:TooManyStatements
    def create
      return if valid?

      login = shell.ask %(What is your "#{url}" login?)
      password = shell.ask %(What is your "#{url}" password?), echo: false
      shell.say

      new_credentials = credentials.merge key => authenticator.new(login, password).authorization

      file_path = self.class.file_path
      FileUtils.mkdir_p File.dirname file_path
      File.open(file_path, "w") { |file| file << YAML.dump(new_credentials) }
      FileUtils.chmod(0o600, file_path)
    end
    # rubocop:enable Metrics/AbcSize

    private

    attr_reader :credentials, :shell

    def credentials?
      File.exist? self.class.file_path
    end

    def load_credentials
      Hash YAML.load_file(self.class.file_path)
    rescue StandardError
      {}
    end
  end
end
