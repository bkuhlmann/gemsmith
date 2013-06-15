module Gemsmith
  module CLIHelpers
    # Answers the gem name (snake case).
    # ==== Parameters
    # * +name+ - Optional. The gem name. Default: nil
    def gem_name name = nil
      @gem_name ||= Thor::Util.snake_case name
    end

    # Answers the gem class (camel case).
    # ==== Parameters
    # * +name+ - Optional. The gem class. Default: nil
    def gem_class name = nil
      @gem_class ||= Thor::Util.camel_case name
    end

    # Answers the gem install path.
    def install_path
      @install_path ||= File.join Dir.pwd, gem_name
    end

    # Answers all gem template options.
    def template_options
      @template_options
    end

    module_function

    # Prints currently installed gem name and version information.
    # ===== Parameters
    # * +gems+ - Required. The array of gem names (i.e. gem specifications).
    def print_gem_versions gems
      say "Multiple versions found:"
      gems.each_with_index do |spec, index|
        say "#{index + 1}. #{spec.name} #{spec.version.version}"
      end
    end

    # Opens selected gem within default editor.
    # ===== Parameters
    # * +gems+ - Required. The array of gem names (i.e. gem specifications).
    def open_gem gems
      result = ask "Please pick one (or type 'q' to quit):"

      return if result == 'q' # Exit early.

      if (1..gems.size).include?(result.to_i)
        spec = Gem::Specification.find_by_name name, gems[result.to_i - 1].version.version
        `$EDITOR #{spec.full_gem_path}`
      else
        error "Invalid option: #{result}"
      end
    end
  end
end
