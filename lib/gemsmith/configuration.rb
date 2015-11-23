module Gemsmith
  # Default configuration for gem with support for custom settings.
  class Configuration
    attr_reader :file_path
    attr_accessor :gem_name, :gem_class
    attr_writer :gem_platform, :gem_home_url, :gem_license, :gem_private_key, :gem_public_key, :author_name,
                :author_email, :author_url, :organization_name, :organization_email, :organization_url,
                :ruby_version, :rails_version, :create_cli, :create_rails, :create_security, :create_pry,
                :create_guard, :create_rspec, :create_rubocop, :create_code_climate, :create_gemnasium,
                :create_travis, :create_patreon, :github_user, :year

    def initialize gem_name: "unknown", gem_class: "Unknown", file_path: File.join(ENV["HOME"], Identity.file_name)
      @gem_name = gem_name
      @gem_class = gem_class
      @file_path = file_path
      @settings = load_settings
    end

    def gem_platform
      @gem_platform || settings_group(:gem).fetch(:platform, "Gem::Platform::RUBY")
    end

    def gem_home_url
      @gem_home_url || settings_group(:gem).fetch(:home_url, "")
    end

    def gem_license
      @gem_license || settings_group(:gem).fetch(:license, "MIT")
    end

    def gem_private_key
      @gem_private_key || settings_group(:gem).fetch(:private_key, "~/.ssh/gem-private.pem")
    end

    def gem_public_key
      @gem_public_key || settings_group(:gem).fetch(:public_key, "~/.ssh/gem-public.pem")
    end

    def author_name
      @author_name || settings_group(:author).fetch(:name, Gemsmith::Git.config_value("user.name"))
    end

    def author_email
      @author_email || settings_group(:author).fetch(:email, Gemsmith::Git.config_value("user.email"))
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
      @ruby_version || settings_group(:versions).fetch(:ruby, "2.2.3")
    end

    def rails_version
      @rails_version || settings_group(:versions).fetch(:rails, "4.2")
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

    def create_rubocop?
      parse_boolean @create_rubocop, :create, :rubocop, true
    end

    def create_code_climate?
      parse_boolean @create_code_climate, :create, :code_climate, true
    end

    def create_gemnasium?
      parse_boolean @create_gemnasium, :create, :gemnasium, true
    end

    def create_travis?
      parse_boolean @create_travis, :create, :travis, true
    end

    def create_patreon?
      parse_boolean @create_patreon, :create, :patreon, true
    end

    def github_user
      @github_user || settings.fetch(:github_user, Gemsmith::Git.config_value("github.user"))
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
          class: gem_class,
          platform: gem_platform,
          home_url: gem_home_url,
          license: gem_license,
          private_key: gem_private_key,
          public_key: gem_public_key
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
          code_climate: create_code_climate?,
          gemnasium: create_gemnasium?,
          travis: create_travis?,
          patreon: create_patreon?
        }
      }
    end

    private

    attr_reader :settings

    def load_settings
      return {} unless File.exist?(file_path)
      yaml = YAML.load_file file_path
      yaml.is_a?(Hash) ? yaml : {}
    end

    def settings_group key
      settings.fetch key, {}
    end

    def parse_boolean variable, group_key, item_key, default_value
      return variable if [true, false].include?(variable)
      settings_group(group_key).fetch item_key, default_value
    end
  end
end
