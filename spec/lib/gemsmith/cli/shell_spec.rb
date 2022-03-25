# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Shell do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:shell) { described_class.new }

  include_context "with application container"

  describe "#call" do
    let :project_files do
      temp_dir.join("test")
              .files("**/*", flag: File::FNM_DOTMATCH)
              .reject { |path| path.fnmatch?("*git/*") && !path.fnmatch?("*git/HEAD") }
              .reject { |path| path.fnmatch? "*tags" }
              .map { |path| path.relative_path_from(temp_dir).to_s }
    end

    context "with minimum forced build" do
      let :options do
        %w[
          --build
          test
          --min
        ]
      end

      let :files do
        [
          "test/.ruby-version",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV["CI"] == "true"),
          "test/lib/test.rb",
          "test/test.gemspec"
        ].compact
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to contain_exactly(*files)
        end
      end
    end

    context "with minimum optional build" do
      let :options do
        %w[
          --build
          test
          --no-amazing_print
          --no-bundler-leak
          --no-caliber
          --no-circle_ci
          --no-citation
          --no-cli
          --no-community
          --no-conduct
          --no-console
          --no-contributions
          --no-dead_end
          --no-debug
          --no-git
          --no-git-lint
          --no-git_hub
          --no-guard
          --no-license
          --no-rake
          --no-readme
          --no-reek
          --no-refinements
          --no-rspec
          --no-security
          --no-setup
          --no-simple_cov
          --no-versions
          --no-zeitwerk
        ]
      end

      let :files do
        [
          "test/.ruby-version",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV["CI"] == "true"),
          "test/lib/test.rb",
          "test/test.gemspec"
        ].compact
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to contain_exactly(*files)
        end
      end
    end

    context "with maximum forced build" do
      let :options do
        %w[
          --build
          test
          --max
        ]
      end

      let :files do
        [
          "test/.circleci/config.yml",
          "test/.git/HEAD",
          "test/.github/ISSUE_TEMPLATE.md",
          "test/.github/PULL_REQUEST_TEMPLATE.md",
          "test/.gitignore",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.ruby-version",
          "test/bin/console",
          "test/bin/guard",
          "test/bin/rubocop",
          "test/bin/setup",
          "test/CITATION.cff",
          "test/exe/test",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV["CI"] == "true"),
          "test/Guardfile",
          "test/lib/test.rb",
          "test/lib/test/cli/actions/config.rb",
          "test/lib/test/cli/actions/container.rb",
          "test/lib/test/cli/actions/import.rb",
          "test/lib/test/cli/parser.rb",
          "test/lib/test/cli/parsers/core.rb",
          "test/lib/test/cli/shell.rb",
          "test/lib/test/configuration/content.rb",
          "test/lib/test/configuration/defaults.yml",
          "test/lib/test/configuration/loader.rb",
          "test/lib/test/container.rb",
          "test/lib/test/import.rb",
          "test/LICENSE.adoc",
          "test/Rakefile",
          "test/README.adoc",
          "test/spec/lib/test/cli/actions/config_spec.rb",
          "test/spec/lib/test/cli/parser_spec.rb",
          "test/spec/lib/test/cli/parsers/core_spec.rb",
          "test/spec/lib/test/cli/shell_spec.rb",
          "test/spec/lib/test/configuration/content_spec.rb",
          "test/spec/lib/test/configuration/loader_spec.rb",
          "test/spec/spec_helper.rb",
          "test/spec/support/shared_contexts/application_container.rb",
          "test/spec/support/shared_contexts/temp_dir.rb",
          "test/spec/support/shared_examples/a_parser.rb",
          "test/test.gemspec",
          "test/VERSIONS.adoc"
        ].compact
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to contain_exactly(*files)
        end
      end
    end

    context "with maximum optional build" do
      let :options do
        %w[
          --build
          test
          --amazing_print
          --bundler-leak
          --caliber
          --circle_ci
          --citation
          --cli
          --community
          --conduct
          --console
          --contributions
          --dead_end
          --debug
          --git
          --git-lint
          --git_hub
          --guard
          --license
          --rake
          --readme
          --reek
          --refinements
          --rspec
          --security
          --setup
          --simple_cov
          --versions
          --zeitwerk
        ]
      end

      let :files do
        [
          "test/.circleci/config.yml",
          "test/.git/HEAD",
          "test/.github/ISSUE_TEMPLATE.md",
          "test/.github/PULL_REQUEST_TEMPLATE.md",
          "test/.gitignore",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.ruby-version",
          "test/bin/console",
          "test/bin/guard",
          "test/bin/rubocop",
          "test/bin/setup",
          "test/CITATION.cff",
          "test/exe/test",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV["CI"] == "true"),
          "test/Guardfile",
          "test/lib/test.rb",
          "test/lib/test/cli/actions/config.rb",
          "test/lib/test/cli/actions/container.rb",
          "test/lib/test/cli/actions/import.rb",
          "test/lib/test/cli/parser.rb",
          "test/lib/test/cli/parsers/core.rb",
          "test/lib/test/cli/shell.rb",
          "test/lib/test/configuration/content.rb",
          "test/lib/test/configuration/defaults.yml",
          "test/lib/test/configuration/loader.rb",
          "test/lib/test/container.rb",
          "test/lib/test/import.rb",
          "test/LICENSE.adoc",
          "test/Rakefile",
          "test/README.adoc",
          "test/spec/lib/test/cli/actions/config_spec.rb",
          "test/spec/lib/test/cli/parser_spec.rb",
          "test/spec/lib/test/cli/parsers/core_spec.rb",
          "test/spec/lib/test/cli/shell_spec.rb",
          "test/spec/lib/test/configuration/content_spec.rb",
          "test/spec/lib/test/configuration/loader_spec.rb",
          "test/spec/spec_helper.rb",
          "test/spec/support/shared_contexts/application_container.rb",
          "test/spec/support/shared_contexts/temp_dir.rb",
          "test/spec/support/shared_examples/a_parser.rb",
          "test/test.gemspec",
          "test/VERSIONS.adoc"
        ].compact
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to contain_exactly(*files)
        end
      end
    end

    it "prints version" do
      expectation = proc { shell.call %w[--version] }
      expect(&expectation).to output(/Gemsmith\s\d+\.\d+\.\d+/).to_stdout
    end

    it "prints help (usage)" do
      expectation = proc { shell.call %w[--help] }
      expect(&expectation).to output(/Gemsmith.+USAGE.+BUILD OPTIONS/m).to_stdout
    end

    it "prints usage when no options are given" do
      expectation = proc { shell.call }
      expect(&expectation).to output(/Gemsmith.+USAGE.+BUILD OPTIONS.+/m).to_stdout
    end

    it "prints error with invalid option" do
      expectation = proc { shell.call %w[--bogus] }
      expect(&expectation).to output(/invalid option.+bogus/).to_stdout
    end
  end
end
