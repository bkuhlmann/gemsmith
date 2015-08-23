module Gemsmith
  # Command Line Interface (CLI) helpers that aid the CLI class. These are extracted to a module
  # in order to not clutter up the main CLI object.
  module CLIHelpers
    # Answers default editor.
    # NOTE: This will be replaced by the Thor+ gem in the future.
    def editor
      ENV["EDITOR"]
    end

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

    # Answers all gem template options.
    def template_options
      @template_options
    end

    module_function

    # Converts hash keys from strings to symbols (if any).
    # ===== Parameters
    # * +options+ - Optional. The hash to convert. Default: {}
    def enforce_symbol_keys options = {}
      options.each.with_object({}) { |(key, value), hash| hash[key.to_sym] = value }
    end

    # Prints currently installed gem name and version information.
    # ===== Parameters
    # * +gems+ - Required. The array of gem names (i.e. gem specifications).
    def print_gems gems
      say "Multiple versions found:"
      gems.each.with_index do |spec, index|
        say "#{index + 1}. #{spec.name} #{spec.version.version}"
      end
    end

    # Picks a gem specification for processing.
    # ===== Parameters
    # * +gems+ - Required. The array of gem specifications.
    # * +name+ - Required. The gem name to search for.
    def pick_gem gems, name
      result = ask "Please pick one (or type 'q' to quit):"

      return if result == "q" # Exit early.

      if (1..gems.size).include?(result.to_i)
        Gem::Specification.find_by_name name, gems[result.to_i - 1].version.version
      else
        error "Invalid option: #{result}"
        nil
      end
    end

    # Opens selected gem within default editor.
    # ===== Parameters
    # * +spec+ - Required. The gem specification.
    def open_gem spec
      `#{editor} #{spec.full_gem_path}` if spec
    end

    # Opens selected gem within default browser.
    # ===== Parameters
    # * +spec+ - Required. The gem specification.
    def read_gem spec
      `open #{spec.homepage}` if spec
    end

    # Processes a gem for given name and command.
    # ===== Parameters
    # * +name+ - Required. The gem name.
    # * +command+ - Required. The command to process the gem.
    def process_gem name, command
      specs = Gem::Specification.find_all_by_name name

      case
        when specs.size == 1
          send "#{command}_gem", specs.first
        when specs.size > 1
          print_gems specs
          send "#{command}_gem", pick_gem(specs, name)
        else
          say "Unable to find gem: #{name}"
      end
    end
  end
end
