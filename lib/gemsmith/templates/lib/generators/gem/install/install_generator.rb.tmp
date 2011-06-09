module <%= config[:gem_class] %>
  class InstallGenerator < Rails::Generators::Base
    desc "Installs <%= config[:gem_class] %> resources."

    # Override the default source path by pulling from a shared templates directory for all generators.
    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), "..", "templates")
    end

    # Let others know about you.
    def self.banner
      "rails generate <%= config[:gem_name] %>:install"
    end

    # TODO - Explain yourself.
    def copy_files
      # TODO - Add your fancy/schmancy install code here.
    end
  end
end
