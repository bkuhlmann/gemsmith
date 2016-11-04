# frozen_string_literal: true

require "refinements/strings"
require "runcom"

module Gemsmith
  # Default configuration for gem with support for custom settings.
  class Configuration < Runcom::Configuration
    using Refinements::Strings

    attr_reader :gem_name, :gem_path, :gem_class
    attr_writer :gem_platform, :gem_home_url, :gem_license, :author_name, :author_email,
                :author_url, :organization_name, :organization_email, :organization_url,
                :ruby_version, :rails_version, :create_cli, :create_rails, :create_security,
                :create_pry, :create_guard, :create_rspec, :create_rubocop, :create_git_hub,
                :create_code_climate, :create_gemnasium, :create_travis, :create_patreon,
                :publish_sign, :github_user, :year

    def initialize file_name: Identity.file_name, defaults: {}, gem_name: "unknown", git: Git
      super file_name: file_name, defaults: defaults
      @gem_name = gem_name
      @gem_path = gem_name.snakecase
      @gem_class = gem_name.camelcase
      @git = git
    end

    def gem_platform
      @gem_platform || settings_group(:gem).fetch(:platform, "Gem::Platform::RUBY")
    end

    def gem_home_url
      @gem_home_url || settings_group(:gem).fetch(:home_url, github_gem_url)
    end

    def gem_license
      @gem_license || settings_group(:gem).fetch(:license, "MIT")
    end

    def author_name
      @author_name || settings_group(:author).fetch(:name, git.config_value("user.name"))
    end

    def author_email
      @author_email || settings_group(:author).fetch(:email, git.config_value("user.email"))
    end

    def author_url
      @author_url || settings_group(:author).fetch(:url, "")
    end

    def organization_name
      @organization_name || settings_group(:organization).fetch(:name, "")
    end

    def organization_url
      @organization_url || settings_group(:organization).fetch(:url, "")
    end

    def ruby_version
      @ruby_version || settings_group(:versions).fetch(:ruby, RUBY_VERSION)
    end

    def rails_version
      @rails_version || settings_group(:versions).fetch(:rails, "5.0")
    end

    def create_cli?
      parse_boolean @create_cli, :create, :cli, false
    end

    def create_rails?
      parse_boolean @create_rails, :create, :rails, false
    end

    def create_security?
      parse_boolean @create_security, :create, :security, true
    end

    def create_pry?
      parse_boolean @create_pry, :create, :pry, true
    end

    def create_guard?
      parse_boolean @create_guard, :create, :guard, true
    end

    def create_rspec?
      parse_boolean @create_rspec, :create, :rspec, true
    end

    def create_git_hub?
      parse_boolean @create_git_hub, :create, :git_hub, false
    end

    def create_rubocop?
      parse_boolean @create_rubocop, :create, :rubocop, true
    end

    def create_code_climate?
      parse_boolean @create_code_climate, :create, :code_climate, false
    end

    def create_gemnasium?
      parse_boolean @create_gemnasium, :create, :gemnasium, false
    end

    def create_travis?
      parse_boolean @create_travis, :create, :travis, false
    end

    def create_patreon?
      parse_boolean @create_patreon, :create, :patreon, false
    end

    def publish_sign?
      parse_boolean @publish_sign, :publish, :sign, false
    end

    def github_user
      @github_user || settings.fetch(:github_user, git.config_value("github.user"))
    end

    def year
      @year || settings.fetch(:year, Time.now.year)
    end

    def to_h
      {
        year: year,
        github_user: github_user,
        gem: {
          name: gem_name,
          path: gem_path,
          class: gem_class,
          platform: gem_platform,
          home_url: gem_home_url,
          license: gem_license
        },
        author: {
          name: author_name,
          email: author_email,
          url: author_url
        },
        organization: {
          name: organization_name,
          url: organization_url
        },
        versions: {
          ruby: ruby_version,
          rails: rails_version
        },
        create: {
          cli: create_cli?,
          rails: create_rails?,
          security: create_security?,
          pry: create_pry?,
          guard: create_guard?,
          rspec: create_rspec?,
          rubocop: create_rubocop?,
          git_hub: create_git_hub?,
          code_climate: create_code_climate?,
          gemnasium: create_gemnasium?,
          travis: create_travis?,
          patreon: create_patreon?
        },
        publish: {
          sign: publish_sign?
        }
      }
    end

    private

    attr_reader :gem_parser, :git

    def settings_group key
      settings.fetch key, {}
    end

    def parse_boolean variable, group_key, item_key, default_value
      return variable if [true, false].include?(variable)
      settings_group(group_key).fetch item_key, default_value
    end

    def github_gem_url
      return "" if github_user.nil?
      "https://github.com/#{github_user}/#{gem_name}"
    end
  end
end
