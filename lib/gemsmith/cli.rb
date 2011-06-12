require "yaml"
require "thor"
require "thor/actions"

module Gemsmith
  class CLI < Thor
    include Thor::Actions

    # Overwritten Thor template source root.
    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "templates")
    end
    
    # Initialize.
    def initialize args = [], options = {}, config = {}
      super
      
      # Defaults.
      @shell = shell
      @settings_file = File.join ENV["HOME"], ".gemsmith", "settings.yml"

      # Load and apply custom settings (if any).
      load_settings
    end

    desc "-c, [create=GEM_NAME]", "Create new gem."
    map "-c" => :create
    method_option :bin, :aliases => "-b", :desc => "Adds binary support.", :type => :boolean, :default => false
    method_option :rails, :aliases => "-R", :desc => "Adds Rails support.", :type => :boolean, :default => false
    method_option :rspec, :aliases => "-r", :desc => "Add RSpec support.", :type => :boolean, :default => true
    def create name
      shell.say "\nCreating gem..."

      # Initialize options.
      gem_name = underscore name
      gem_class = classify gem_name
      author_name = @settings[:author_name] || `git config user.name`.chomp || "TODO: Write full name here."
      author_url = @settings[:author_url] || "TODO: Write home page URL here."
      template_options = {
        :gem_name => gem_name,
        :gem_class => gem_class,
        :gem_platform => (@settings[:gem_platform] || "Gem::Platform::RUBY"),
        :author_name => author_name,
        :author_email => (@settings[:author_email] || `git config user.email`.chomp || "TODO: Write email address here."),
        :author_url => author_url,
        :company_name => (@settings[:company_name] || author_name),
        :company_url => (@settings[:company_url] || author_url),
        :year => Time.now.year,
        :rails => options[:rails]
      }

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
      if options[:bin]
        template File.join("bin", "gem.tmp"), File.join(target_path, "bin", gem_name), template_options
      end

      # Ruby on Rails (optional).
      if options[:rails]
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
        template File.join("lib", "generators", "gem", "upgrade", "upgrade_generator.rb.tmp"), File.join(target_path, "lib", "generators", gem_name, "upgrade", "upgrade_generator.rb"), template_options
      end

      # RSpec (optional).
      if options[:rspec]
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
      
      shell.say "Gem created: #{gem_name}\n\n"
    end

    desc "-v, [version]", "Show version."
    map "-v" => :version
    def version
      print_version
    end
    
    desc "-h, [help]", "Show this message."
    def help task = nil
      shell.say and super
    end

    private

    # Transforms a camelcased string to an underscored equivalent (code stolen from the Ruby on Rails ActiveSupport underscore method).
    # ==== Examples
    # * "ExampleGem" -> "example_gem"
    # * "SSLGem" -> "ssl_gem"
    # ==== Parameters
    # * +string+ - The string to underscore.
    def underscore string
      string = string.to_s.dup
      string.gsub! /([A-Z]+)([A-Z][a-z])/, '\1_\2'
      string.gsub! /([a-z\d])([A-Z])/, '\1_\2'
      string.tr! "-", "_"
      string.downcase
     end
     
     # Transforms a lowercased/camelcased to a proper class name (code inspired by the Ruby on Rails ActiveSupport classify method).
     # ==== Examples
     # * "example" -> "example"
     # * "my_cool_gem" -> "MyCoolGem"
     # ==== Parameters
     # * +string+ - The string to classify.
     def classify string
       string = string.to_s.dup
       string.gsub!(/(^.{1}|_.)/) {$1.upcase}
       string.tr '_', ''
     end
    
    # Load settings.
    def load_settings
      if File.exists? @settings_file
        begin
          settings = YAML::load_file @settings_file
          @settings = settings.reject {|key, value| value.nil?}
        rescue
          shell.say "ERROR: Invalid settings: #{@settings_file}."
        end
      end
    end
    
    # Print version information.
    def print_version
      shell.say "Gemsmith " + VERSION
    end
  end
end
