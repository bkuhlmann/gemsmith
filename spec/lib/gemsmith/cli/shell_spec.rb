# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Shell do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Sod::Container.stub! kernel:, logger: }

  after { Sod::Container.restore }

  describe "#call" do
    let :bom_minimum do
      ["test/.ruby-version", "test/Gemfile", "test/lib/test.rb", "test/test.gemspec"].compact
    end

    let :bom_maximum do
      SPEC_ROOT.join("support/fixtures/boms/maximum.txt").each_line(chomp: true).compact
    end

    let :project_files do
      temp_dir.join("test")
              .files("**/*", flag: File::FNM_DOTMATCH)
              .reject { |path| path.fnmatch?("*git/*") && !path.fnmatch?("*git/HEAD") }
              .reject { |path| path.fnmatch? "*tags" }
              .map { |path| path.relative_path_from(temp_dir).to_s }
    end

    it "prints configuration usage" do
      shell.call %w[config]
      expect(kernel).to have_received(:puts).with(/Manage configuration.+/m)
    end

    context "with minimum forced build" do
      let(:options) { %w[build --name test --min] }

      it "builds minimum skeleton" do
        temp_dir.change_dir do
          shell.call options
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
          shell.call options
          expect(project_files).to match_array(bom_minimum)
        end
      end
    end

    context "with maximum forced build" do
      let(:options) { %w[build --name test --max] }

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          shell.call options
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
          shell.call options
          expect(project_files).to match_array(bom_maximum)
        end
      end
    end

    it "attempts to install gem" do
      temp_dir.change_dir do
        expectation = proc { shell.call %w[--install test-0.0.0.gem] }
        expect(&expectation).to raise_error(Gem::SystemExitException)
      end
    end

    it "attempts to publish gem" do
      temp_dir.change_dir do
        expectation = proc { shell.call %w[--publish test-0.0.0.gem] }
        expect(&expectation).to raise_error(Gem::SystemExitException)
      end
    end

    it "attempts to edit gem" do
      shell.call %w[--edit test]
      expect(logger.reread).to match(/🛑.+Unknown.+gem.+test/)
    end

    it "attempts to view gem" do
      shell.call %w[--view test]
      expect(logger.reread).to match(/🛑.+Unknown.+gem.+test/)
    end

    it "prints version" do
      shell.call %w[--version]
      expect(kernel).to have_received(:puts).with(/Gemsmith\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(kernel).to have_received(:puts).with(/Gemsmith.+USAGE.+/m)
    end
  end
end
