module Gemsmith
  module Skeletons
    # Configures Pry debugging support.
    class PrySkeleton < BaseSkeleton
      def create
        return unless configuration.create_pry?
        cli.template "%gem_name%/spec/support/extensions/pry.rb.tt", configuration.to_h
      end
    end
  end
end
