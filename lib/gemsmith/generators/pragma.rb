# frozen_string_literal: true

require "pathname"
require "pragmater"

module Gemsmith
  module Generators
    # Formats pragma comments in source files.
    class Pragma < Base
      DEFAULT_COMMENTS = ["# frozen_string_literal: true"].freeze

      def run
        Pragmater::Runner.new(
          gem_root,
          comments: DEFAULT_COMMENTS,
          includes: includes
        ).run action: :add
      end

      # rubocop:disable Metrics/MethodLength
      def includes
        %W[
          **/*Gemfile
          **/*Guardfile
          **/*Rakefile
          **/*config.ru
          **/*bin/#{configuration.dig :gem, :name}
          **/*bin/bundle
          **/*bin/rails
          **/*bin/rake
          **/*bin/setup
          **/*bin/update
          **/*bin/yarn
          **/*.gemspec
          **/*.rake
          **/*.rb
        ]
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
