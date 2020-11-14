# frozen_string_literal: true

module Gemsmith
  # A thin wrapper to Git.
  # rubocop:disable Style/StaticClass
  class Git
    def self.config_value key
      `git config #{key}`.chomp
    end

    def self.github_user
      config_value "github.user"
    end

    def self.github_url project
      return "" if github_user.empty?

      "https://github.com/#{github_user}/#{project}"
    end
  end
  # rubocop:enable Style/StaticClass
end
