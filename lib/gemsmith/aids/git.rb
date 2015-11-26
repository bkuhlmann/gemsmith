module Gemsmith
  module Aids
    # A thin wrapper to Git.
    class Git
      def self.config_value key
        `git config #{key}`.chomp
      end
    end
  end
end
