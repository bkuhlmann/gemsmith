module Gemsmith
  module Skeletons
    # Configures Rake support.
    class RakeSkeleton < BaseSkeleton
      def create_console_task
        cli.template "%gem_name%/lib/tasks/console.rake.tt", configuration.to_h
      end

      def create
        create_console_task
        cli.template "%gem_name%/Rakefile.tt", configuration.to_h
        configure_rakefile
      end

      private

      def rspec_task
        "spec" if configuration.create_rspec?
      end

      def rubocop_task
        "rubocop" if configuration.create_rubocop?
      end

      def default_tasks
        [rspec_task, rubocop_task].compact
      end

      def configure_rakefile
        return if default_tasks.empty?
        cli.append_to_file "%gem_name%/Rakefile", %(\ntask default: %w(#{default_tasks.join(" ")})\n)
      end
    end
  end
end
