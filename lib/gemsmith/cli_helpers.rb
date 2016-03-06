# frozen_string_literal: true

module Gemsmith
  # Command Line Interface (CLI) helpers for the CLI class.
  module CLIHelpers
    def gem_name
      configuration.gem_name
    end

    def gem_class
      configuration.gem_class
    end

    def rails_version
      configuration.rails_version
    end

    module_function

    def print_gems gems
      say "Multiple versions found:\n\n"
      gems.each.with_index { |spec, index| say "#{index + 1}. #{spec.name} #{spec.version.version}" }
      say "q. Quit.\n\n"
    end

    def pick_gem gems, name
      answer = ask "Enter selection:"
      return if answer == "q"

      if (1..gems.size).cover?(answer.to_i)
        gem_spec.find name, gems[answer.to_i - 1].version.version
      else
        error "Invalid option: #{answer}"
      end
    end

    def open_gem specification, method
      spec = gem_spec.new specification.spec_file
      spec.public_send method
    end

    def process_gem name, method
      specs = gem_spec.find_all name

      case
        when specs.size == 1
          open_gem specs.first, method
        when specs.size > 1
          print_gems specs
          open_gem pick_gem(specs, name), method
        else
          error("Unable to find gem: #{name}.") && ""
      end
    end
  end
end
