# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton Circle CI configuration.
    class CircleCI < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        return configuration unless configuration.build_circle_ci

        builder.call(configuration.merge(template_path: "%project_name%/.circleci/config.yml.erb"))
               .replace %({{checksum "Gemfile.lock"}}),
                        %({{checksum "Gemfile"}}-{{checksum "#{project_name}.gemspec"}})

        configuration
      end

      private

      def project_name = configuration.project_name
    end
  end
end
