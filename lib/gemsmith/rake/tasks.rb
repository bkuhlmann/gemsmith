require "bundler/gem_tasks"
require "gemsmith/rake/build"

module Gemsmith
  module Rake
    class Tasks
      include ::Rake::DSL

      def self.setup
        new.install
      end

      def install
        ::Rake::Task[:build].enhance [:clean, "readme:toc"]
        ::Rake::Task[:release].enhance { ::Rake::Task[:clean].invoke }

        namespace :readme do
          desc "Update README Table of Contents"
          task :toc do
            Gemsmith::Rake::Build.new.table_of_contents
          end
        end

        desc "Cleans gem artifacts."
        task :clean do
          Gemsmith::Rake::Build.new.clean!
        end
      end
    end
  end
end
