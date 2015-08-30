module Gemsmith
  module Skeletons
    # Configures Rake support.
    class RakeSkeleton < BaseSkeleton
      def self.allowed_options
        {
          rspec: "spec",
          rubocop: "rubocop"
        }
      end

      def create
        cli.template "%gem_name%/Rakefile.tt", cli.template_options
        configure_rakefile
      end

      private

      def allowed_options?
        cli.template_options.keys.any? { |key| self.class.allowed_options.keys.include? key }
      end

      def default_tasks
        cli.template_options.each.with_object([]) do |(key, _), tasks|
          tasks.push self.class.allowed_options[key]
        end
      end

      def configure_rakefile
        return unless allowed_options?
        cli.append_to_file "%gem_name%/Rakefile", "\ntask default: %w(#{default_tasks.compact.join(' ')})\n"
      end
    end
  end
end
