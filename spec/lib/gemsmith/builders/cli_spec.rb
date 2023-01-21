# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::CLI do
  using Refinements::Structs
  using Refinements::Pathnames

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:test_configuration) { configuration.minimize }

  before do
    Rubysmith::Builders::Core.call test_configuration
    Rubysmith::Builders::Bundler.call test_configuration
  end

  it_behaves_like "a builder"

  describe "#call" do
    let(:fixtures_root) { SPEC_ROOT.join "support/fixtures" }

    before { builder.call }

    context "when enabled" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true, build_refinements: true, build_zeitwerk: true
      end

      it "builds executable" do
        expect(temp_dir.join("test/exe/test").read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "test"

          Test::CLI::Shell.new.call ARGV
        CONTENT
      end

      it "sets executable as executable" do
        expect(temp_dir.join("test/exe/test").stat.mode).to eq(33261)
      end

      it "builds CLI action config" do
        expect(temp_dir.join("test/lib/test/cli/actions/config.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/actions/config.rb").read
        )
      end

      it "builds CLI action container" do
        expect(temp_dir.join("test/lib/test/cli/actions/container.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/actions/container.rb").read
        )
      end

      it "builds CLI action import" do
        expect(temp_dir.join("test/lib/test/cli/actions/import.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/actions/import.rb").read
        )
      end

      it "builds CLI parser" do
        expect(temp_dir.join("test/lib/test/cli/parser.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/parser.rb").read
        )
      end

      it "builds CLI core parser" do
        expect(temp_dir.join("test/lib/test/cli/parsers/core.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/parsers/core.rb").read
        )
      end

      it "builds CLI shell" do
        expect(temp_dir.join("test/lib/test/cli/shell.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/shell.rb").read
        )
      end

      it "builds configuration defaults" do
        expect(temp_dir.join("test/lib/test/configuration/defaults.yml").read).to eq("")
      end

      it "builds configuration loader" do
        expect(temp_dir.join("test/lib/test/configuration/loader.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/configuration/loader.rb").read
        )
      end

      it "builds application container" do
        expect(temp_dir.join("test/lib/test/container.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/container.rb").read
        )
      end

      it "builds application import" do
        expect(temp_dir.join("test/lib/test/import.rb").read).to eq(<<~CONTENT)
          require "infusible"

          module Test
            Import = Infusible.with Container
          end
        CONTENT
      end
    end

    context "when enabled with RSpec" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true,
                                     build_refinements: true,
                                     build_rspec: true,
                                     build_zeitwerk: true
      end

      it "builds RSpec CLI actions config spec" do
        expect(temp_dir.join("test/spec/lib/test/cli/actions/config_spec.rb").read).to include(
          "RSpec.describe Test::CLI::Actions::Config do\n"
        )
      end

      it "builds RSpec CLI parser spec" do
        expect(temp_dir.join("test/spec/lib/test/cli/parser_spec.rb").read).to include(
          "RSpec.describe Test::CLI::Parser do\n"
        )
      end

      it "builds RSpec CLI core parser spec" do
        expect(temp_dir.join("test/spec/lib/test/cli/parsers/core_spec.rb").read).to include(
          "RSpec.describe Test::CLI::Parsers::Core do\n"
        )
      end

      it "builds RSpec CLI shell spec" do
        expect(temp_dir.join("test/spec/lib/test/cli/shell_spec.rb").read).to eq(
          fixtures_root.join("spec/lib/cli/shell_proof.rb").read
        )
      end

      it "builds RSpec configuration content spec" do
        expect(temp_dir.join("test/spec/lib/test/configuration/content_spec.rb").read).to include(
          "RSpec.describe Test::Configuration::Content do\n"
        )
      end

      it "builds RSpec configuration loader spec" do
        expect(temp_dir.join("test/spec/lib/test/configuration/loader_spec.rb").read).to eq(
          fixtures_root.join("spec/lib/configuration/loader_proof.rb").read
        )
      end

      it "builds RSpec application container shared context" do
        template_path = temp_dir.join(
          "test/spec/support/shared_contexts/application_dependencies.rb"
        )
        fixture_path = fixtures_root.join "spec/support/shared_contexts/application_dependencies.rb"

        expect(template_path.read).to eq(fixture_path.read)
      end

      it "builds RSpec shared example for a parser" do
        expect(temp_dir.join("test/spec/support/shared_examples/a_parser.rb").read).to eq(<<~BODY)
          RSpec.shared_examples "a parser" do
            describe ".call" do
              it "answers configuration" do
                expect(described_class.call).to be_a(Test::Configuration::Content)
              end
            end
          end
        BODY
      end
    end

    context "when enabled with simple project name" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true, build_refinements: true, build_zeitwerk: true
      end

      it "adds CLI inflection" do
        expect(temp_dir.join("test/lib/test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.for_gem.then do |loader|
            loader.inflector.inflect "cli" => "CLI"
            loader.setup
          end

          # Main namespace.
          module Test
          end
        CONTENT
      end
    end

    context "when enabled with dashed project name" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true,
                                     build_refinements: true,
                                     build_zeitwerk: true,
                                     project_name: "demo-test"
      end

      it "adds CLI inflection" do
        expect(temp_dir.join("demo-test/lib/demo/test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.push_dir "\#{__dir__}/.."
            loader.inflector.inflect "cli" => "CLI"
            loader.setup
          end

          module Demo
            # Main namespace.
            module Test
            end
          end
        CONTENT
      end

      it "builds application container nested project path to gemspec" do
        expect(temp_dir.join("demo-test/lib/demo/test/container.rb").read).to include(
          %(register(:specification) { Spek::Loader.call "\#{__dir__}/../../../demo-test.gemspec" })
        )
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build file" do
        expect(temp_dir.join("test/exe/test").exist?).to be(false)
      end
    end
  end
end
