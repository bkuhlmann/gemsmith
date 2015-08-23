module Gemsmith
  module Skeletons
    # Configures Rake support.
    class RakeSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/Rakefile.tt", template_options
        configure_rakefile
      end

      private

      def default_tasks
        template_options.each.with_object([]) do |(key, _), tasks|
          tasks << "spec" if key == :rspec
          tasks
        end
      end

      def configure_rakefile
        return unless template_options[:rspec]
        append_to_file "%gem_name%/Rakefile", "\ntask default: %w(#{default_tasks.join(' ')})\n"
      end
    end
  end
end
