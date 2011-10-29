require "yaml"
require "thor"
require "thor/actions"

module Gemsmith
  class CLI < Thor
    include Thor::Actions
    include Gemsmith::Utilities

    # Overwrites the Thor template source root.
    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "templates")
    end
    
    # Initialize.
    def initialize args = [], options = {}, config = {}
      super
      load_settings settings_file
    end

    desc "-c, [create=GEM_NAME]", "Create new gem."
    map "-c" => :create
    method_option :bin, aliases: "-b", desc: "Add binary support.", type: :boolean, default: false
    method_option :rails, aliases: "-r", desc: "Add Rails support.", type: :boolean, default: false
    method_option :rspec, aliases: "-s", desc: "Add RSpec support.", type: :boolean, default: true
    def create name
      say
      say_info "Creating gem..."

      # Initialize options.
      template_options = build_template_options name, options
      gem_name = template_options[:gem_name]

      # Configure templates.
      target_path = File.join Dir.pwd, gem_name
      
      # Default templates.
      template "README.rdoc.tmp", File.join(target_path, "README.rdoc"), template_options
      template "CHANGELOG.rdoc.tmp", File.join(target_path, "CHANGELOG.rdoc"), template_options
      template "LICENSE.rdoc.tmp", File.join(target_path, "LICENSE.rdoc"), template_options
      template "Gemfile.tmp", File.join(target_path, "Gemfile"), template_options
      template "Rakefile.tmp", File.join(target_path, "Rakefile"), template_options
      template "gitignore.tmp", File.join(target_path, ".gitignore"), template_options
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
      end

      # RSpec (optional).
      if template_options[:rspec]
        template "rspec.tmp", File.join(target_path, ".rspec"), template_options
        template File.join("spec", "spec_helper.rb.tmp"), File.join(target_path, "spec", "spec_helper.rb"), template_options
        template File.join("spec", "gem_spec.rb.tmp"), File.join(target_path, "spec", "#{gem_name}_spec.rb"), template_options
      end
      
      # Git
      Dir.chdir(target_path) do
        `git init`
        `git add .`
        `git commit -a -n -m "Gemsmith skeleton created."`
      end
      
      say_info "Gem created."
      say
    end
    
    desc "-e, [edit]", "Edit gem settings in default editor (assumes $EDITOR environment variable)."
    map "-e" => :edit
    def edit
      `$EDITOR #{settings_file}`
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

    # Answers the default settings file path.
    def settings_file
      @settings_file ||= File.join ENV["HOME"], ".gemsmith", "settings.yml"
    end

    # Load settings.
    # ==== Parameters
    # * +file+ - Required. The path to the settings (YAML) file.
    def load_settings file
      if file && File.exists?(file)
        begin
          settings = YAML::load_file file
          @settings = settings.reject {|key, value| value.nil?}
        rescue
          say_error "Invalid settings: #{file}."
        end
      end
    end

    # Answers current settings.
    def settings
      @settings ||= {}
    end
    
    # Builds template options with default and/or custom settings (where the custom
    # settings trump default settings).
    # ==== Parameters
    # * +name+ - Required. The gem name.
    # * +options+ - Optional. Additional command line options. Default: {}
    def build_template_options name, options = {}
      gem_name = Thor::Util.snake_case name
      gem_class = Thor::Util.camel_case name
      author_name = settings[:author_name] || `git config user.name`.chomp || "TODO: Add full name here."
      author_email = settings[:author_email] || `git config user.email`.chomp || "TODO: Add email address here."
      author_url = settings[:author_url] || "https://www.unknown.com"
      {
        gem_name: gem_name,
        gem_class: gem_class,
        gem_platform: (settings[:gem_platform] || "Gem::Platform::RUBY"),
        author_name: author_name,
        author_email: author_email,
        author_url: author_url,
        gem_url: (settings[:gem_url] || author_url),
        company_name: (settings[:company_name] || author_name),
        company_url: (settings[:company_url] || author_url),
        year: (settings[:year] || Time.now.year),
        bin: (options[:bin] || false),
        rails: (options[:rails] || false),
        rspec: (options[:rspec].nil? ? true : options[:rspec]),
        ruby_version: (settings[:ruby_version] || "1.9.0"),
        rails_version: (settings[:rails_version] || "3.1.0")
      }
    end
  end
end
