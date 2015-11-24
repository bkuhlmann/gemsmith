module Gemsmith
  # Command Line Interface (CLI) helpers for the CLI class.
  module CLIHelpers
    def editor
      ENV["EDITOR"]
    end

    def gem_name
      configuration.gem_name
    end

    def gem_class
      configuration.gem_class
    end

    module_function

    def print_gems gems
      say "Multiple versions found:"
      gems.each.with_index do |spec, index|
        say "#{index + 1}. #{spec.name} #{spec.version.version}"
      end
    end

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

    def open_gem spec
      `#{editor} #{spec.full_gem_path}` if spec
    end

    def read_gem spec
      `open #{spec.homepage}` if spec
    end

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
