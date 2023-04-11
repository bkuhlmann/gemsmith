# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Shell do
  using Refinements::Pathnames
  using Refinements::Structs
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Gemsmith::CLI::Actions::Import.stub configuration:, kernel:, executor: }

  after { Gemsmith::CLI::Actions::Import.unstub :configuration, :kernel, :executor }

  describe "#call" do
    let :bom_minimum do
      [
        "test/.ruby-version",
        "test/Gemfile",
        ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
        "test/lib/test.rb",
        "test/test.gemspec"
      ].compact
    end

    let :bom_maximum do
      SPEC_ROOT.join("support/fixtures/boms/maximum.txt")
               .readlines(chomp: true)
               .push(("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"))
               .compact
    end

    let :project_files do
      temp_dir.join("test")
              .files("**/*", flag: File::FNM_DOTMATCH)
              .reject { |path| path.fnmatch?("*git/*") && !path.fnmatch?("*git/HEAD") }
              .reject { |path| path.fnmatch? "*tags" }
              .map { |path| path.relative_path_from(temp_dir).to_s }
    end

    it "edits configuration" do
      shell.call %w[--config edit]
      expect(kernel).to have_received(:system).with(include("EDITOR"))
    end

    it "views configuration" do
      shell.call %w[--config view]
      expect(kernel).to have_received(:system).with(include("cat"))
    end

    context "with minimum forced build" do
      let(:options) { %w[--build test --min] }

      it "builds minimum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to match_array(bom_minimum)
        end
      end
    end

    context "with minimum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/minimum.txt").readlines chomp: true
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to match_array(bom_minimum)
        end
      end
    end

    context "with maximum forced build" do
      let(:options) { %w[--build test --max] }

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to match_array(bom_maximum)
        end
      end
    end

    context "with maximum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/maximum.txt").readlines chomp: true
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to match_array(bom_maximum)
        end
      end
    end

    context "with install" do
      let(:install) { instance_spy Gemsmith::CLI::Actions::Install }

      before { Gemsmith::CLI::Actions::Import.stub install: }

      after { Gemsmith::CLI::Actions::Import.unstub install: }

      it "installs gem" do
        shell.call %w[--install test-0.0.0.gem]
        expect(install).to have_received(:call).with(kind_of(Rubysmith::Configuration::Content))
      end
    end

    context "with publish" do
      let(:publish) { instance_spy Gemsmith::CLI::Actions::Publish }

      before { Gemsmith::CLI::Actions::Import.stub publish: }

      after { Gemsmith::CLI::Actions::Import.unstub publish: }

      it "publishes gem" do
        shell.call %w[--publish test-0.0.0.gem]
        expect(publish).to have_received(:call).with(kind_of(Rubysmith::Configuration::Content))
      end
    end

    context "with edit" do
      let(:edit) { instance_spy Gemsmith::CLI::Actions::Edit }

      before { Gemsmith::CLI::Actions::Import.stub edit: }

      after { Gemsmith::CLI::Actions::Import.unstub edit: }

      it "edits gem" do
        shell.call %w[--edit test]
        expect(edit).to have_received(:call).with("test")
      end
    end

    context "with view" do
      let(:view) { instance_spy Gemsmith::CLI::Actions::View }

      before { Gemsmith::CLI::Actions::Import.stub view: }

      after { Gemsmith::CLI::Actions::Import.unstub view: }

      it "views gem" do
        shell.call %w[--view test]
        expect(view).to have_received(:call).with("test")
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(kernel).to have_received(:puts).with(/Gemsmith\s\d+\.\d+\.\d+/)
    end

    it "prints help (usage)" do
      shell.call %w[--help]
      expect(kernel).to have_received(:puts).with(/Gemsmith.+USAGE.+BUILD OPTIONS.+/m)
    end

    it "prints usage when no options are given" do
      shell.call
      expect(kernel).to have_received(:puts).with(/Gemsmith.+USAGE.+BUILD OPTIONS.+/m)
    end

    it "prints error with invalid option" do
      expectation = proc { shell.call %w[--bogus] }
      expect(&expectation).to output(/invalid option.+bogus/).to_stdout
    end
  end
end
