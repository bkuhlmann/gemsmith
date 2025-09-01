# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    # Builds project skeleton Circle CI settings.
    class CircleCI < Rubysmith::Builders::CircleCI
      using Refinements::Struct

      def call
        return false unless settings.build_circle_ci

        super
        builder.call(settings.with(template_path: "%project_name%/.circleci/config.yml.erb"))
               .replace %({{checksum "Gemfile.lock"}}),
                        %({{checksum "Gemfile"}}-{{checksum "#{project_name}.gemspec"}})

        true
      end

      private

      def project_name = settings.project_name
    end
  end
end
