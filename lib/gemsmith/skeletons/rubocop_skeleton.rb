module Gemsmith
  module Skeletons
    # Configures Rubocop support.
    class RubocopSkeleton < BaseSkeleton
      def create_files
        template "%gem_name%/.rubocop.yml.tt", template_options
        template "%gem_name%/lib/%gem_name%/tasks/rubocop.rake.tt", template_options
      end
    end
  end
end
