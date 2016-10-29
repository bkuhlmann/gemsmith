# frozen_string_literal: true

require "pragmater"
require "pathname"

module Gemsmith
  module Skeletons
    # Formats pragma comments in source files.
    class PragmaSkeleton < BaseSkeleton
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
          bin/#{configuration.gem_name}
          bin/rails
          .gemspec
          .rake
          .rb
        ]
      end

      def create
        whitelisted_files.each { |file| Pragmater::Writer.new(file, self.class.comments).add }
      end

      private

      def gem_dir
        File.join cli.destination_root, configuration.gem_name
      end

      def whitelisted_files
        Pathname.glob(%(#{gem_dir}/**/*{#{whitelist.join ","}})).select(&:file?)
      end
    end
  end
end
