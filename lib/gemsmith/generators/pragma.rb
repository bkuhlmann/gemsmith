# frozen_string_literal: true

require "pathname"
require "pragmater"

module Gemsmith
  module Generators
    # Formats pragma comments in source files.
    class Pragma < Base
      DEFAULT_COMMENTS = ["# frozen_string_literal: true"].freeze

      def run
        Pragmater::Runner.for(**attributes).call
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

      private

      def attributes
        {
          action: :insert,
          root_dir: gem_root,
          comments: DEFAULT_COMMENTS,
          includes: includes
        }
      end
    end
  end
end
