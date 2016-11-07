# frozen_string_literal: true

module Gemsmith
  # Command Line Interface (CLI) helpers for the CLI class.
  module CLIHelpers
    def gem_name
      generator_configuration.dig :gem, :name
    end

    def gem_path
      generator_configuration.dig :gem, :path
    end

    def gem_class
      generator_configuration.dig :gem, :class
    end

    def rails_version
      generator_configuration.dig :versions, :rails
    end

    def render_namespace &block
      body = capture(&block) if block_given?
      concat Gem::ModuleFormatter.new(gem_class).render(body)
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
        Gem::Specification.find name, gems[answer.to_i - 1].version.version
      else
        error "Invalid option: #{answer}"
        nil
      end
    end

    def inspect_gem specification, method
      return unless specification
      Gem::Inspector.new.public_send method, Gem::Specification.new(specification.spec_file)
    end

    def process_gem name, method
      specs = Gem::Specification.find_all name

      if specs.size == 1
        inspect_gem specs.first, method
      elsif specs.size > 1
        print_gems specs
        inspect_gem pick_gem(specs, name), method
      else
        error("Unable to find gem: #{name}.") and ""
      end
    end
  end
end
