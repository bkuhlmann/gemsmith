# frozen_string_literal: true

require "pragmater"
require "pathname"

module Gemsmith
  module Generators
    # Formats pragma comments in source files.
    class Pragma < Base
      def self.comments
        ["# frozen_string_literal: true"]
      end

      # rubocop:disable Metrics/MethodLength
      def whitelist
        %W[
          Gemfile
          Guardfile
          Rakefile
          config.ru
          bin/#{configuration.dig :gem, :name}
          bin/rails
          .gemspec
          .rake
          .rb
        ]
      end

      def run
        whitelisted_files.each { |file| Pragmater::Writer.new(file, self.class.comments).add }
      end

      private

      def whitelisted_files
        Pathname.glob(%(#{cli.destination_root}/**/*{#{whitelist.join ","}})).select(&:file?)
      end
    end
  end
end
