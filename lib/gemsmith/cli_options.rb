module Gemsmith
  # Provides Command Line Interface (CLI) settings initialization with safe defaults.
  module CLIOptions
    module_function

    # Initializes template options with default and/or command line overrides.
    # ==== Parameters
    # * +name+ - Required. The gem name.
    # * +options+ - Optional. Additional command line options. Default: {}.
    def initialize_template_options name, options = {}
      @settings.merge! options
      @settings = enforce_symbol_keys @settings

      gem_name name
      gem_class name

      @template_options = {
        gem_name: gem_name,
        gem_class: gem_class,
        gem_platform: gem_platform,
        gem_url: gem_url,
        gem_private_key: gem_private_key,
        gem_public_key: gem_public_key,
        author_name: author_name,
        author_email: author_email,
        author_url: author_url,
        company_name: company_name,
        company_url: company_url,
        github_user: github_user,
        year: year,
        ruby_version: ruby_version,
        rails_version: rails_version,
        post_install_message: @settings[:post_install_message],
        bin: default_boolean(:bin),
        rails: default_boolean(:rails),
        security: default_boolean(:security, true),
        pry: default_boolean(:pry, true),
        guard: default_boolean(:guard, true),
        rspec: default_boolean(:rspec, true),
        rubocop: default_boolean(:rubocop, true),
        code_climate: default_boolean(:code_climate, true),
        gemnasium: default_boolean(:gemnasium, true),
        travis: default_boolean(:travis, true),
        patreon: default_boolean(:patreon, true)
      }
    end

    def gem_platform
      @settings[:gem_platform] || "Gem::Platform::RUBY"
    end

    def gem_url
      @settings[:gem_url] || author_url
    end

    def gem_private_key
      @settings.fetch :gem_private_key, "~/.ssh/gem-private.pem"
    end

    def gem_public_key
      @settings.fetch :gem_public_key, "~/.ssh/gem-public.pem"
    end

    def author_name
      @settings[:author_name] || Gemsmith::Kit.git_config_value("user.name") || "TODO: Add full name."
    end

    def author_email
      @settings[:author_email] || Gemsmith::Kit.git_config_value("user.email") || "TODO: Add email address."
    end

    def author_url
      @settings[:author_url] || "https://www.unknown.com"
    end

    def company_name
      @settings[:company_name] || author_name
    end

    def company_url
      @settings[:company_url] || author_url
    end

    def github_user
      @settings[:github_user] || Gemsmith::Kit.git_config_value("github.user") || "unknown"
    end

    def year
      @settings[:year] || Time.now.year
    end

    def ruby_version
      @settings[:ruby_version] || "2.2.3"
    end

    def rails_version
      @settings[:rails_version] || "4.2"
    end

    def default_boolean key, value = false
      @settings.key?(key) ? @settings[key] : value
    end
  end
end
