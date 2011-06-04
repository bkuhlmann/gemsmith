require "yaml"
require "thor"

module Gemsmith
  class CLI < Thor
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
    def create name
      shell.say "Creating gem..."
      options = {}
      target = File.join Dir.pwd, name
      template File.join("README.temp"), File.join(target, "README.rdoc"), options
      template File.join("CHANGELOG.temp"), File.join(target, "CHANGELOG.rdoc"), options
      template File.join("LICENSE.temp"), File.join(target, "LICENSE.rdoc"), options
      shell.say "Gem created: #{name}"
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

    protected
    
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
    
    # Save settings.
    # ==== Parameters
    # * +settings+ - Required. Saves settings to file.
    def save_settings settings
      File.open(@settings_file, 'w') {|file| file << YAML::dump(settings)}
    end

    # Print version information.
    def print_version
      shell.say "Gemsmith " + VERSION
    end
  end
end
