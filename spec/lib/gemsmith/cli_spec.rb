# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI do
  subject :cli do
    load "gemsmith/cli.rb" # Ensures clean Thor `.method_option` evaluation per spec.
    described_class.start command_line
  end

  include_context "with Git repository"

  using Refinements::Pathnames

  let(:options) { [] }
  let(:command_line) { Array(command).concat options }

  shared_examples_for "a generate command" do
    let(:gem_name) { "tester" }
    let(:gem_dir) { temp_dir.join gem_name }
    let(:files) { gem_dir.change_dir { `git ls-files` }.split }

    context "with no options" do
      let :options do
        [
          gem_name,
          "--no-bundler-audit",
          "--no-circle-ci",
          "--no-cli",
          "--no-engine",
          "--no-git-lint",
          "--no-git-hub",
          "--no-guard",
          "--no-pry",
          "--no-reek",
          "--no-rspec",
          "--no-rubocop",
          "--no-simple-cov",
          "--no-security"
        ]
      end

      let :expected_files do
        [
          ".gitignore",
          ".ruby-version",
          "bin/console",
          "bin/setup",
          "lib/tester/identity.rb",
          "lib/tester.rb",
          "CHANGES.md",
          "CODE_OF_CONDUCT.md",
          "CONTRIBUTING.md",
          "Gemfile",
          "LICENSE.md",
          "README.md",
          "Rakefile",
          "tester.gemspec"
        ]
      end

      it "generates basic gem" do
        temp_dir.change_dir do
          cli
          expect(files).to contain_exactly(*expected_files)
        end
      end
    end

    context "with CLI option only" do
      let :options do
        [
          gem_name,
          "--cli"
        ]
      end

      let :expected_files do
        [
          ".gitignore",
          ".reek.yml",
          ".rubocop.yml",
          ".ruby-version",
          "bin/console",
          "bin/setup",
          "bin/tester",
          "lib/tester/identity.rb",
          "lib/tester/cli.rb",
          "lib/tester.rb",
          "spec/lib/tester/cli_spec.rb",
          "spec/support/shared_contexts/temp_dir.rb",
          "spec/spec_helper.rb",
          "CHANGES.md",
          "CODE_OF_CONDUCT.md",
          "CONTRIBUTING.md",
          "Gemfile",
          "Guardfile",
          "LICENSE.md",
          "README.md",
          "Rakefile",
          "tester.gemspec"
        ]
      end

      it "generates CLI gem" do
        ClimateControl.modify XDG_CONFIG_HOME: temp_dir.to_s do
          temp_dir.change_dir do
            cli
            expect(files).to contain_exactly(*expected_files)
          end
        end
      end
    end

    context "with all options (minus CLI)" do
      let :options do
        [
          gem_name,
          "--bundler-audit",
          "--circle-ci",
          "--engine",
          "--git-lint",
          "--git-hub",
          "--guard",
          "--pry",
          "--reek",
          "--rspec",
          "--rubocop",
          "--simple-cov",
          "--security"
        ]
      end

      let(:controllers_dir) { gem_dir.join "app", "controllers", gem_name }
      let(:mailers_dir) { gem_dir.join "app", "mailers", gem_name }
      let(:models_dir) { gem_dir.join "app", "models", gem_name }

      let :expected_files do
        [
          ".gitignore",
          ".reek.yml",
          ".rubocop.yml",
          ".ruby-version",
          ".github/ISSUE_TEMPLATE.md",
          ".github/PULL_REQUEST_TEMPLATE.md",
          "bin/console",
          "bin/setup",
          "app/controllers/tester/application_controller.rb",
          "app/mailers/tester/application_mailer.rb",
          "app/models/tester/application_record.rb",
          "lib/generators/tester/install/USAGE",
          "lib/generators/tester/install/install_generator.rb",
          "lib/generators/tester/upgrade/USAGE",
          "lib/generators/tester/upgrade/upgrade_generator.rb",
          "lib/tester/engine.rb",
          "lib/tester/identity.rb",
          "lib/tester.rb",
          "spec/support/shared_contexts/temp_dir.rb",
          "spec/rails_helper.rb",
          "spec/spec_helper.rb",
          "CHANGES.md",
          "CODE_OF_CONDUCT.md",
          "circle.yml",
          "CONTRIBUTING.md",
          "Gemfile",
          "Guardfile",
          "LICENSE.md",
          "Rakefile",
          "README.md",
          "tester.gemspec"
        ]
      end

      # FIX: Remove this before block once it is determined why `rails plugin new` doesn't run via
      # the `Generators::Rails#create_engine` within this spec.
      before do
        controllers_dir.make_path.join("application_controller.rb").touch
        mailers_dir.make_path.join("application_mailer.rb").touch
        models_dir.make_path.join("application_record.rb").touch
      end

      it "generates full gem" do
        temp_dir.change_dir do
          cli
          expect(files).to contain_exactly(*expected_files)
        end
      end
    end

    context "with CLI and Rails Engine options only" do
      let :options do
        [
          gem_name,
          "--cli",
          "--engine"
        ]
      end

      it "generates basic gem" do
        temp_dir.change_dir do
          cli
          expect(gem_dir.exist?).to eq(false)
        end
      end

      it "prints error message" do
        temp_dir.change_dir do
          result = -> { cli }
          expect(&result).to output(/.+is\snot\sallowed.+/).to_stdout
        end
      end
    end
  end

  shared_examples_for "a config command" do
    context "with no options" do
      it "prints help text" do
        result = -> { cli }
        expect(&result).to output(/Manage gem configuration./).to_stdout
      end
    end
  end

  shared_examples_for "an open command" do
    let(:options) { %w[gemsmith_test] }

    it "attempts to open gem" do
      result = -> { cli }
      expect(&result).not_to raise_error
    end
  end

  shared_examples_for "a read command" do
    let(:options) { %w[gemsmith_test] }

    it "attempts to read gem" do
      result = -> { cli }
      expect(&result).not_to raise_error
    end
  end

  shared_examples_for "a version command" do
    it "prints version" do
      result = -> { cli }
      expect(&result).to output(/#{Gemsmith::Identity::VERSION_LABEL}\n/o).to_stdout
    end
  end

  shared_examples_for "a help command" do
    it "prints usage" do
      result = -> { cli }
      expect(&result).to output(/#{Gemsmith::Identity::VERSION_LABEL}\scommands:\n/o).to_stdout
    end
  end

  describe ".source_root" do
    it "answers source root" do
      expect(described_class.source_root.to_s).to end_with("lib/gemsmith/templates")
    end
  end

  describe ".configuration" do
    let :defaults do
      {
        year: Time.now.year,
        github_user: "test",
        gem: {
          label: "Undefined",
          name: "undefined",
          path: "undefined",
          class: "Undefined",
          platform: "Gem::Platform::RUBY",
          url: "",
          license: "MIT"
        },
        author: {
          name: "Test User",
          email: "test@example.com",
          url: ""
        },
        organization: {
          name: "",
          url: ""
        },
        versions: {
          ruby: ENV["RUBY_VERSION"],
          rails: "6.1"
        },
        generate: {
          bundler_audit: true,
          circle_ci: false,
          cli: false,
          engine: false,
          git_lint: true,
          git_hub: false,
          guard: true,
          pry: true,
          reek: true,
          rspec: true,
          rubocop: true,
          simple_cov: true,
          security: false
        },
        publish: {
          sign: false
        }
      }
    end

    it "answers default settings" do
      ClimateControl.modify XDG_CONFIG_HOME: git_repo_dir.to_s do
        git_repo_dir.change_dir do
          `git config --add github.user test`
          expect(described_class.configuration.to_h).to eq(defaults)
        end
      end
    end
  end

  describe ".generators" do
    let :expected_generators do
      [
        Gemsmith::Generators::Gem,
        Gemsmith::Generators::Documentation,
        Gemsmith::Generators::Rake,
        Gemsmith::Generators::CLI,
        Gemsmith::Generators::Ruby,
        Gemsmith::Generators::Engine,
        Gemsmith::Generators::BundlerAudit,
        Gemsmith::Generators::GitCop,
        Gemsmith::Generators::GitLint,
        Gemsmith::Generators::Rspec,
        Gemsmith::Generators::Reek,
        Gemsmith::Generators::Rubocop,
        Gemsmith::Generators::Guard,
        Gemsmith::Generators::CircleCI,
        Gemsmith::Generators::Bundler,
        Gemsmith::Generators::Git,
        Gemsmith::Generators::Pragma,
        Gemsmith::Generators::GitHub
      ]
    end

    it "answers gem generators" do
      expect(described_class.generators).to contain_exactly(*expected_generators)
    end
  end

  describe "--generate" do
    let(:command) { "--generate" }

    it_behaves_like "a generate command"
  end

  describe "-g" do
    let(:command) { "-g" }

    it_behaves_like "a generate command"
  end

  describe "--open" do
    let(:command) { "--open" }

    it_behaves_like "an open command"
  end

  describe "-o" do
    let(:command) { "-o" }

    it_behaves_like "an open command"
  end

  describe "--read" do
    let(:command) { "--read" }

    it_behaves_like "a read command"
  end

  describe "-r" do
    let(:command) { "-r" }

    it_behaves_like "a read command"
  end

  describe "--config" do
    let(:command) { "--config" }

    it_behaves_like "a config command"
  end

  describe "-c" do
    let(:command) { "-c" }

    it_behaves_like "a config command"
  end

  describe "--version" do
    let(:command) { "--version" }

    it_behaves_like "a version command"
  end

  describe "-v" do
    let(:command) { "-v" }

    it_behaves_like "a version command"
  end

  describe "--help" do
    let(:command) { "--help" }

    it_behaves_like "a help command"
  end

  describe "-h" do
    let(:command) { "-h" }

    it_behaves_like "a help command"
  end

  context "with no command" do
    let(:command) { nil }

    it_behaves_like "a help command"
  end
end
