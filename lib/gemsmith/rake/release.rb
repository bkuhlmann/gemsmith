require "milestoner"

module Gemsmith
  module Rake
    # Provides gem release functionality. Meant to be wrapped in Rake tasks.
    class Release
      def initialize gem_spec_path = Dir.glob("#{Dir.pwd}/*.gemspec").first,
                     bundler: Bundler,
                     tagger: Milestoner::Tagger.new,
                     shell: Bundler::UI::Shell.new

        @gem_spec_path = gem_spec_path
        @tagger = tagger
        @shell = shell
        @gem_spec = bundler.load_gemspec gem_spec_path.to_s
      rescue Errno::ENOENT
        @shell.error "Invalid gemspec file path: #{@gem_spec_path}."
      end

      def version_number
        gem_spec.version.version
      end

      def version_label
        "v#{version_number}"
      end

      def gem_file_name
        "#{gem_spec.name}-#{version_number}.gem"
      end

      def publish
        tagger.create version_number, sign: true
      rescue Milestoner::Errors::Base => error
        shell.error error.message
      end

      private

      attr_reader :gem_spec_path, :gem_spec, :tagger, :shell
    end
  end
end
