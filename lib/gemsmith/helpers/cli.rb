# frozen_string_literal: true

module Gemsmith
  module Helpers
    # Command Line Interface (CLI) helpers for the CLI class.
    module CLI
      module_function

      def print_gems gems
        say "Multiple versions found:\n\n"

        gems.each.with_index do |spec, index|
          say "#{index + 1}. #{spec.name} #{spec.version.version}"
        end

        say "q. Quit.\n\n"
      end

      def pick_gem gems, name
        answer = ask "Enter selection:"
        return if answer == "q"

        answer = answer.to_i

        if (1..gems.size).cover?(answer)
          Gem::Specification.find name, gems[answer - 1].version.version
        else
          error "Invalid option: #{answer}"
          nil
        end
      end

      def inspect_gem specification, method
        return unless specification
        Gem::Inspector.new.public_send method, Gem::Specification.new(specification.spec_file)
      rescue Versionaire::Errors::Conversion => exception
        error(exception.message)
      end

      def process_gem name, method
        specs = Gem::Specification.find_all name
        spec_count = specs.size

        if spec_count == 1
          inspect_gem specs.first, method
        elsif spec_count > 1
          print_gems specs
          inspect_gem pick_gem(specs, name), method
        else
          error("Unable to find gem: #{name}.") and ""
        end
      end
    end
  end
end
