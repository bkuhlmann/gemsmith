# frozen_string_literal: true

require "yaml"
require "refinements/pathnames"
require "gemsmith/authenticators/basic"
require "gemsmith/authenticators/ruby_gems"

module Gemsmith
  # Generates gem credentials for RubyGems and/or alternative servers.
  class Credentials
    DEFAULT_KEY = :rubygems_api_key
    DEFAULT_URL = "https://rubygems.org"

    using Refinements::Pathnames

    attr_reader :key, :url

    def self.file_path
      Pathname(ENV.fetch("HOME")).join ".gem", "credentials"
    end

    def self.authenticators
      [Authenticators::RubyGems, Authenticators::Basic]
    end

    def initialize key: DEFAULT_KEY, url: DEFAULT_URL, shell: Thor::Shell::Basic.new
      @key = key
      @url = url
      @shell = shell
      @credentials = read
    end

    def authenticator
      self.class
          .authenticators
          .find { |auth| auth.url.include? url }
          .then { |selected| selected || Authenticators::Basic }
    end

    def value
      String credentials[key]
    end

    def valid?
      exist? && !String(credentials[key]).empty?
    end

    def create
      write unless valid?
    end

    private

    attr_reader :credentials, :shell

    def exist?
      self.class.file_path.exist?
    end

    def read
      Hash YAML.load_file(self.class.file_path)
    rescue StandardError
      {}
    end

    def write
      self.class
          .file_path
          .tap { |path| path.parent.make_path }
          .write(YAML.dump(update))
          .chmod 0o600
    end

    def update
      login = shell.ask %(What is your "#{url}" login?)
      password = shell.ask %(What is your "#{url}" password?), echo: false
      shell.say

      credentials.merge key => authenticator.new(login, password).authorization
    end
  end
end
