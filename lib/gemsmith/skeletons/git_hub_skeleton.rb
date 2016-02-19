# frozen_string_literal: true

module Gemsmith
  module Skeletons
    # Configures GitHub support.
    class GitHubSkeleton < BaseSkeleton
      def create
        return unless configuration.create_git_hub?
        cli.template "%gem_name%/.github/ISSUE_TEMPLATE.md.tt", configuration.to_h
        cli.template "%gem_name%/.github/PULL_REQUEST_TEMPLATE.md.tt", configuration.to_h
      end
    end
  end
end
