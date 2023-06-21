# frozen_string_literal: true

require "sod"

module Gemsmith
  module CLI
    module Commands
      # Handles the build action.
      class Build < Sod::Command
        include Import[:input, :logger]

        # Order is important.
        BUILDERS = [
          Rubysmith::Builders::Init,
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
          Rubysmith::Builders::Git::Safe,
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
          Rubysmith::Builders::RSpec::Binstub,
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

        handle "build"

        description "Build new project."

        on Rubysmith::CLI::Actions::Name, input: Container[:input]
        on Rubysmith::CLI::Actions::AmazingPrint, input: Container[:input]
        on Rubysmith::CLI::Actions::Caliber, input: Container[:input]
        on Rubysmith::CLI::Actions::CircleCI, input: Container[:input]
        on Rubysmith::CLI::Actions::Citation, input: Container[:input]
        on Actions::CLI
        on Rubysmith::CLI::Actions::Community, input: Container[:input]
        on Rubysmith::CLI::Actions::Conduct, input: Container[:input]
        on Rubysmith::CLI::Actions::Console, input: Container[:input]
        on Rubysmith::CLI::Actions::Contributions, input: Container[:input]
        on Rubysmith::CLI::Actions::Debug, input: Container[:input]
        on Rubysmith::CLI::Actions::Funding, input: Container[:input]
        on Rubysmith::CLI::Actions::Git, input: Container[:input]
        on Rubysmith::CLI::Actions::GitHub, input: Container[:input]
        on Rubysmith::CLI::Actions::GitHubCI, input: Container[:input]
        on Rubysmith::CLI::Actions::GitLint, input: Container[:input]
        on Rubysmith::CLI::Actions::Guard, input: Container[:input]
        on Rubysmith::CLI::Actions::License, input: Container[:input]
        on Rubysmith::CLI::Actions::Maximum, input: Container[:input]
        on Rubysmith::CLI::Actions::Minimum, input: Container[:input]
        on Rubysmith::CLI::Actions::Rake, input: Container[:input]
        on Rubysmith::CLI::Actions::Readme, input: Container[:input]
        on Rubysmith::CLI::Actions::Reek, input: Container[:input]
        on Rubysmith::CLI::Actions::Refinements, input: Container[:input]
        on Rubysmith::CLI::Actions::RSpec, input: Container[:input]
        on Rubysmith::CLI::Actions::Security, input: Container[:input]
        on Rubysmith::CLI::Actions::Setup, input: Container[:input]
        on Rubysmith::CLI::Actions::SimpleCov, input: Container[:input]
        on Rubysmith::CLI::Actions::Versions, input: Container[:input]
        on Rubysmith::CLI::Actions::Yard, input: Container[:input]
        on Rubysmith::CLI::Actions::Zeitwerk, input: Container[:input]

        def initialize(builders: BUILDERS, **)
          super(**)
          @builders = builders
        end

        def call
          log_info "Building project skeleton: #{input.project_name}..."
          builders.each { |builder| builder.call input }
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
