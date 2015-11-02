module Gemsmith
  module Skeletons
    # Configures Pry debugging support.
    class PrySkeleton < BaseSkeleton
      def enabled?
        cli.template_options.key?(:pry) && cli.template_options[:pry]
      end

      def create
        return unless enabled?
        cli.template "%gem_name%/spec/support/extensions/pry.rb.tt", cli.template_options
      end
    end
  end
end
