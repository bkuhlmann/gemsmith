require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"

module Gemsmith
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions

    # Overwrites the Thor template source root.
    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "templates")
    end

    # Initialize.
    def initialize args = [], options = {}, config = {}
      super args, options, config
      @settings_file = File.join ENV["HOME"], ".gemsmith", "settings.yml"
      @settings = load_yaml @settings_file
    end

    desc "-c, [create=GEM_NAME]", "Create new gem."
    map "-c" => :create
    method_option :bin, aliases: "-b", desc: "Add binary support.", type: :boolean, default: false
    method_option :rails, aliases: "-r", desc: "Add Rails support.", type: :boolean, default: false
    method_option :pry, aliases: "-p", desc: "Add Pry support.", type: :boolean, default: true
    method_option :guard, aliases: "-g", desc: "Add Guard support.", type: :boolean, default: true
    method_option :rspec, aliases: "-s", desc: "Add RSpec support.", type: :boolean, default: true
    method_option :travis, aliases: "-t", desc: "Add Travis CI support.", type: :boolean, default: true
    method_option :code_climate, aliases: "-c", desc: "Add Code Climate support.", type: :boolean, default: true
    def create name
      say
      info "Creating gem..."

      # Initialize options.
      template_options = build_template_options name, @settings, options
      gem_name = template_options[:gem_name]

      # Configure templates.
      target_path = File.join Dir.pwd, gem_name

      # Default templates.
      template "README.rdoc.tmp", File.join(target_path, "README.rdoc"), template_options
      template "CONTRIBUTING.md.tmp", File.join(target_path, "CONTRIBUTING.md"), template_options
      template "LICENSE.rdoc.tmp", File.join(target_path, "LICENSE.rdoc"), template_options
      template "CHANGELOG.rdoc.tmp", File.join(target_path, "CHANGELOG.rdoc"), template_options
      template "Gemfile.tmp", File.join(target_path, "Gemfile"), template_options
      template "Rakefile.tmp", File.join(target_path, "Rakefile"), template_options
      template "gitignore.tmp", File.join(target_path, ".gitignore"), template_options
      template "ruby-version.tmp", File.join(target_path, ".ruby-version"), template_options
      template "gem.gemspec.tmp", File.join(target_path, "#{gem_name}.gemspec"), template_options
      template File.join("lib", "gem.rb.tmp"), File.join(target_path, "lib", "#{gem_name}.rb"), template_options
      template File.join("lib", "gem", "version.rb.tmp"), File.join(target_path, "lib", gem_name, "version.rb"), template_options

      # Binary (optional).
      if template_options[:bin]
        template File.join("bin", "gem.tmp"), File.join(target_path, "bin", gem_name), template_options
        template File.join("lib", "gem", "cli.rb.tmp"), File.join(target_path, "lib", gem_name, "cli.rb"), template_options
      end

      # Ruby on Rails (optional).
      if template_options[:rails]
        # ActionController
        template File.join("lib", "gem", "action_controller", "class_methods.rb.tmp"), File.join(target_path, "lib", gem_name, "action_controller", "class_methods.rb"), template_options
        template File.join("lib", "gem", "action_controller", "instance_methods.rb.tmp"), File.join(target_path, "lib", gem_name, "action_controller", "instance_methods.rb"), template_options
        # ActionView
        template File.join("lib", "gem", "action_view", "instance_methods.rb.tmp"), File.join(target_path, "lib", gem_name, "action_view", "instance_methods.rb"), template_options
        # ActiveRecord
        template File.join("lib", "gem", "active_record", "class_methods.rb.tmp"), File.join(target_path, "lib", gem_name, "active_record", "class_methods.rb"), template_options
        template File.join("lib", "gem", "active_record", "instance_methods.rb.tmp"), File.join(target_path, "lib", gem_name, "active_record", "instance_methods.rb"), template_options
        # Generators
        empty_directory File.join(target_path, "lib", "generators", gem_name, "templates")
        template File.join("lib", "generators", "gem", "install", "install_generator.rb.tmp"), File.join(target_path, "lib", "generators", gem_name, "install", "install_generator.rb"), template_options
        template File.join("lib", "generators", "gem", "install", "USAGE.tmp"), File.join(target_path, "lib", "generators", gem_name, "install", "USAGE"), template_options
        template File.join("lib", "generators", "gem", "upgrade", "upgrade_generator.rb.tmp"), File.join(target_path, "lib", "generators", gem_name, "upgrade", "upgrade_generator.rb"), template_options
        template File.join("lib", "generators", "gem", "upgrade", "USAGE.tmp"), File.join(target_path, "lib", "generators", gem_name, "upgrade", "USAGE"), template_options
        # Travis CI (optional).
        if template_options[:travis]
          template File.join("gemfiles", "rails-3.2.x.gemfile.tmp"), File.join(target_path, "gemfiles", "rails-3.2.x.gemfile"), template_options
        end
      end

      # RSpec (optional).
      if template_options[:rspec]
        template "rspec.tmp", File.join(target_path, ".rspec"), template_options
        template File.join("spec", "spec_helper.rb.tmp"), File.join(target_path, "spec", "spec_helper.rb"), template_options
        template File.join("spec", "gem_spec.rb.tmp"), File.join(target_path, "spec", "#{gem_name}_spec.rb"), template_options
      end

      # Travis CI (optional).
      if template_options[:travis]
        template "travis.yml.tmp", File.join(target_path, ".travis.yml"), template_options
      end

      # Git
      Dir.chdir(target_path) do
        `git init`
        `git add .`
        `git commit -a -n -m "Gemsmith skeleton created."`
      end

      info "Gem created."
      say
    end

    desc "-o, [open=NAME]", "Opens gem in default editor (assumes $EDITOR environment variable)."
    map "-o" => :open
    def open name
      specs = Gem::Specification.find_all_by_name name
      case
      when specs.size == 1
        `$EDITOR #{specs.first.full_gem_path}`
      when specs.size > 1
        say "Multiple versions found:"
        specs.each_with_index do |spec, index|
          say "#{index + 1}. #{spec.name} #{spec.version.version}"
        end
        result = ask "Please pick one (or type 'q' to quit):"
        unless result == 'q'
          if (1..specs.size).include?(result.to_i)
            spec = Gem::Specification.find_by_name(name, specs[result.to_i - 1].version.version)
            `$EDITOR #{spec.full_gem_path}`
          else
            error "Invalid option: #{result}"
          end
        end
      else
        say "Unable to find gem: #{name}"
      end
    end

    desc "-e, [edit]", "Edit gem settings in default editor (assumes $EDITOR environment variable)."
    map "-e" => :edit
    def edit
      `$EDITOR #{@settings_file}`
    end

    desc "-v, [version]", "Show version."
    map "-v" => :version
    def version
      say "Gemsmith " + VERSION
    end

    desc "-h, [help]", "Show this message."
    def help task = nil
      say and super
    end

    private

    # Builds template options with default and/or custom settings (where the custom
    # settings trump default settings).
    # ==== Parameters
    # * +gem_name+ - Required. The gem name.
    # * +settings+ - Optional. The custom settings. Default: {}.
    # * +options+ - Optional. Additional command line options. Default: {}.
    def build_template_options gem_name, settings = {}, options = {}
      gem_name = Thor::Util.snake_case gem_name
      gem_class = Thor::Util.camel_case gem_name
      author_name = settings[:author_name] || Gemsmith::Kit.git_config_value("user.name") || "TODO: Add full name here."
      author_email = settings[:author_email] || Gemsmith::Kit.git_config_value("user.email") || "TODO: Add email address here."
      author_url = settings[:author_url] || "https://www.unknown.com"
      {
        gem_name: gem_name,
        gem_class: gem_class,
        gem_platform: (settings[:gem_platform] || "Gem::Platform::RUBY"),
        author_name: author_name,
        author_email: author_email,
        author_url: (author_url || "http://www.unknown.com"),
        gem_url: (settings[:gem_url] || author_url),
        company_name: (settings[:company_name] || author_name),
        company_url: (settings[:company_url] || author_url),
        github_user: (settings[:github_user] || Gemsmith::Kit.git_config_value("github.user") || "unknown"),
        year: (settings[:year] || Time.now.year),
        ruby_version: (settings[:ruby_version] || "2.0.0"),
        ruby_patch: (settings[:ruby_patch] || "p0"),
        rails_version: (settings[:rails_version] || "3.0"),
        post_install_message: settings[:post_install_message],
        bin: (options[:bin] || false),
        rails: (options[:rails] || false),
        pry: (options[:pry] || true),
        guard: (options[:guard] || true),
        rspec: (options[:rspec] || true),
        travis: (options[:travis] || true),
        code_climate: (options[:code_climate] || true)
      }
    end
  end
end
