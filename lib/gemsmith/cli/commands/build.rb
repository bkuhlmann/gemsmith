# frozen_string_literal: true

require "sod"

module Gemsmith
  module CLI
    module Commands
      # Handles the build action.
      class Build < Sod::Command
        include Dependencies[:settings, :logger]

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
          Builders::Git::Ignore,
          Rubysmith::Builders::Git::Safe,
          Builders::Bundler,
          Builders::CLI,
          Rubysmith::Builders::Rake::Binstub,
          Rubysmith::Builders::Rake::Configuration,
          Builders::Console,
          Builders::CircleCI,
          Rubysmith::Builders::Setup,
          Rubysmith::Builders::GitHub::Template,
          Rubysmith::Builders::GitHub::Funding,
          Rubysmith::Builders::GitHub::CI,
          Rubysmith::Builders::Reek,
          Rubysmith::Builders::RSpec::Binstub,
          Rubysmith::Builders::RSpec::Context,
          Builders::RSpec::Helper,
          Rubysmith::Builders::Caliber,
          Rubysmith::Builders::DevContainer::Dockerfile,
          Rubysmith::Builders::DevContainer::Compose,
          Rubysmith::Builders::DevContainer::Configuration,
          Rubysmith::Builders::Docker::Build,
          Rubysmith::Builders::Docker::Console,
          Rubysmith::Builders::Docker::Entrypoint,
          Rubysmith::Builders::Docker::File,
          Rubysmith::Builders::Docker::Ignore,
          Rubysmith::Extensions::Bundler,
          Rubysmith::Extensions::Pragmater,
          Rubysmith::Extensions::Tocer,
          Rubysmith::Extensions::Rubocop,
          Builders::Git::Commit
        ].freeze

        handle "build"

        description "Build new project."

        on Rubysmith::CLI::Actions::Name, settings: Container[:settings]
        on Rubysmith::CLI::Actions::AmazingPrint, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Bootsnap, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Caliber, settings: Container[:settings]
        on Rubysmith::CLI::Actions::CircleCI, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Citation, settings: Container[:settings]
        on Actions::CLI
        on Rubysmith::CLI::Actions::Community, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Conduct, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Console, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Contributions, settings: Container[:settings]
        on Rubysmith::CLI::Actions::DCOO, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Debug, settings: Container[:settings]
        on Rubysmith::CLI::Actions::DevContainer, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Docker, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Funding, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Git, settings: Container[:settings]
        on Rubysmith::CLI::Actions::GitHub, settings: Container[:settings]
        on Rubysmith::CLI::Actions::GitHubCI, settings: Container[:settings]
        on Rubysmith::CLI::Actions::GitLint, settings: Container[:settings]
        on Rubysmith::CLI::Actions::IRBKit, settings: Container[:settings]
        on Rubysmith::CLI::Actions::License, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Maximum, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Minimum, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Monads, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Rake, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Readme, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Reek, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Refinements, settings: Container[:settings]
        on Rubysmith::CLI::Actions::RSpec, settings: Container[:settings]
        on Rubysmith::CLI::Actions::RTC, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Security, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Setup, settings: Container[:settings]
        on Rubysmith::CLI::Actions::SimpleCov, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Versions, settings: Container[:settings]
        on Rubysmith::CLI::Actions::Zeitwerk, settings: Container[:settings]

        def initialize(builders: BUILDERS, **)
          super(**)
          @builders = builders
        end

        def call
          log_info "Building project skeleton: #{settings.project_name}..."
          builders.each { |builder| builder.new(settings:, logger:).call }
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
