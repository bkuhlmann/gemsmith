# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates Reek support.
    class Reek < Base
      def run
        if configuration.dig :generate, :reek
          template "%gem_name%/.reek.yml.tt"
        else
          cli.gsub_file "#{gem_name}/Rakefile", /require.+reek.+\n/, ""
          cli.gsub_file "#{gem_name}/Rakefile", /Reek.+\n/, ""
        end
      end
    end
  end
end
