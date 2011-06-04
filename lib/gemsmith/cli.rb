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
    method_option :bin, :aliases => "-b", :desc => "Add binary to gem build.", :type => :boolean, :default => false
    def create name
      shell.say "\nCreating gem..."

      # Initialize options.
      gem_name = name.downcase
      gem_class = gem_name.capitalize
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
        :year => Time.now.year
      }

      # Apply templates.
      target_path = File.join Dir.pwd, gem_name
      empty_directory File.join(target_path, "lib", gem_name)
      template "README.rdoc.tmp", File.join(target_path, "README.rdoc"), template_options
      template "CHANGELOG.rdoc.tmp", File.join(target_path, "CHANGELOG.rdoc"), template_options
      template "LICENSE.rdoc.tmp", File.join(target_path, "LICENSE.rdoc"), template_options
      template "Gemfile.tmp", File.join(target_path, "Gemfile"), template_options
      template "Rakefile.tmp", File.join(target_path, "Rakefile"), template_options
      template "gitignore.tmp", File.join(target_path, ".gitignore"), template_options
      template "gem.gemspec.tmp", File.join(target_path, "#{gem_name}.gemspec"), template_options
      template File.join("lib", "gem.rb.tmp"), File.join(target_path, "lib", "#{gem_name}.rb"), template_options
      template File.join("lib", "gem", "version.rb.tmp"), File.join(target_path, "lib", gem_name, "version.rb"), template_options
      if options[:bin]
        template File.join("bin", "gem.tmp"), File.join(target_path, "bin", gem_name), template_options
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
