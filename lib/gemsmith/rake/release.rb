require "bundler/ui/shell"

module Gemsmith
  module Rake
    # Enhances gem publishing with release functionality. Meant to be wrapped in Rake tasks.
    class Release
      def initialize gem_spec_path = Dir.glob("#{Dir.pwd}/*.gemspec").first,
                     shell: Bundler::UI::Shell.new,
                     kernel: Kernel

        @gem_spec_path = gem_spec_path
        @shell = shell
        @kernel = kernel

        @gem_spec = load_gem_spec
      end

      def name
        gem_spec.name
      end

      def version
        gem_spec.version.version
      end

      def version_formatted
        "v#{version}"
      end

      def package_file_name
        "#{name}-#{version}.gem"
      end

      def tag
        shell.error(%(Tag #{version_formatted} exists!)) && return if tagged?

        return if kernel.system %(git tag --sign --annotate "#{version_formatted}" --message "Version #{version}.")

        kernel.system "git tag -d #{version_formatted}"
        shell.error %(Removed "#{version_formatted}" due to errors.)
      end

      def push
        kernel.system "git push --tags"
      end

      private

      attr_reader :gem_spec_path, :gem_spec, :shell, :kernel

      def load_gem_spec
        Bundler.load_gemspec gem_spec_path.to_s
      rescue Errno::ENOENT
        shell.error "Invalid gemspec file path: #{gem_spec_path}."
      end

      def tagged?
        kernel.system %(git show #{version_formatted})
      end
    end
  end
end
