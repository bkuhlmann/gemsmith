# frozen_string_literal: true

require "yaml"
require "fileutils"
require "gemsmith/authenticators/basic"
require "gemsmith/authenticators/ruby_gems"

module Gemsmith
  # Generates gem credentials for RubyGems and/or alternative servers.
  class Credentials
    DEFAULT_KEY = :rubygems_api_key
    DEFAULT_URL = "https://rubygems.org"

    attr_reader :key, :url

    def self.file_path
      File.join ENV.fetch("HOME"), ".gem", "credentials"
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
      selected = self.class.authenticators.find { |auth| auth.url.include? url }
      selected || Authenticators::Basic
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
      File.exist? self.class.file_path
    end

    def read
      Hash YAML.load_file(self.class.file_path)
    rescue StandardError
      {}
    end

    def write
      file_path = self.class.file_path

      FileUtils.mkdir_p File.dirname file_path
      File.open(file_path, "w") { |file| file << YAML.dump(update) }
      FileUtils.chmod 0o600, file_path
    end

    def update
      login = shell.ask %(What is your "#{url}" login?)
      password = shell.ask %(What is your "#{url}" password?), echo: false
      shell.say

      credentials.merge key => authenticator.new(login, password).authorization
    end
  end
end
