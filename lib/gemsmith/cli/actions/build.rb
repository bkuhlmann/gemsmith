# frozen_string_literal: true

module Gemsmith
  module CLI
    module Actions
      # Handles the build action.
      class Build
        # Order is important.
        BUILDERS = [
          Rubysmith::Builders::Core,
          Rubysmith::Builders::Version,
          Builders::Specification,
          Rubysmith::Builders::Documentation::Readme,
          Builders::Documentation::Readme,
          Rubysmith::Builders::Documentation::Citation,
          Rubysmith::Builders::Documentation::License,
          Rubysmith::Builders::Documentation::Version,
          Rubysmith::Builders::Git::Setup,
          Rubysmith::Builders::Git::Ignore,
          Builders::Git::Ignore,
          Rubysmith::Builders::Bundler,
          Builders::Bundler,
          Builders::CLI,
          Rubysmith::Builders::Rake,
          Rubysmith::Builders::Console,
          Rubysmith::Builders::CircleCI,
          Builders::CircleCI,
          Rubysmith::Builders::Setup,
          Rubysmith::Builders::GitHub,
          Rubysmith::Builders::Guard,
          Rubysmith::Builders::Reek,
          Rubysmith::Builders::RSpec::Context,
          Rubysmith::Builders::RSpec::Helper,
          Builders::RSpec::Helper,
          Rubysmith::Builders::Caliber,
          Rubysmith::Extensions::Bundler,
          Rubysmith::Extensions::Pragmater,
          Rubysmith::Extensions::Tocer,
          Rubysmith::Extensions::Rubocop,
          Builders::Git::Commit
        ].freeze

        def initialize builders: BUILDERS
          @builders = builders
        end

        def call(configuration) = builders.each { |builder| builder.call configuration }

        private

        attr_reader :configuration, :builders
      end
    end
  end
end
