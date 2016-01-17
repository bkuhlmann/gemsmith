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
        spec_aid.find name, gems[answer.to_i - 1].version.version
      else
        error "Invalid option: #{answer}"
      end
    end

    def process_gem name, method
      specs = spec_aid.find_all name

      case
        when specs.size == 1
          spec_aid.send method, specs.first
        when specs.size > 1
          print_gems specs
          spec_aid.send method, pick_gem(specs, name)
        else
          error("Unable to find gem: #{name}.") && ""
      end
    end
  end
end
