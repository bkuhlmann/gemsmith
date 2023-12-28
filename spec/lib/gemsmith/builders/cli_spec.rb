# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::CLI do
  using Refinements::Struct
  using Refinements::Pathname

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

          Test::CLI::Shell.new.call
        CONTENT
      end

      it "sets executable as executable" do
        expect(temp_dir.join("test/exe/test").stat.mode).to eq(33261)
      end

      it "builds CLI shell" do
        expect(temp_dir.join("test/lib/test/cli/shell.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/shell.rb").read
        )
      end

      it "builds configuration defaults" do
        expect(temp_dir.join("test/lib/test/configuration/defaults.yml").read).to eq("")
      end

      it "builds configuration contract" do
        expect(temp_dir.join("test/lib/test/configuration/contract.rb").read).to eq(<<~CONTENT)
          require "dry/schema"

          Dry::Schema.load_extensions :monads

          module Test
            module Configuration
              Contract = Dry::Schema.Params
            end
          end
        CONTENT
      end

      it "builds configuration model" do
        expect(temp_dir.join("test/lib/test/configuration/model.rb").read).to eq(<<~CONTENT)
          module Test
            module Configuration
              # Defines the configuration model for use throughout the gem.
              Model = Data.define
            end
          end
        CONTENT
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

      it "builds RSpec CLI shell spec" do
        expect(temp_dir.join("test/spec/lib/test/cli/shell_spec.rb").read).to eq(
          fixtures_root.join("spec/lib/cli/shell_proof.rb").read
        )
      end

      it "builds RSpec application container shared context" do
        template_path = temp_dir.join(
          "test/spec/support/shared_contexts/application_dependencies.rb"
        )
        fixture_path = fixtures_root.join "spec/support/shared_contexts/application_dependencies.rb"

        expect(template_path.read).to eq(fixture_path.read)
      end
    end

    context "when enabled with simple project name" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true, build_refinements: true, build_zeitwerk: true
      end

      it "adds CLI inflection" do
        expect(temp_dir.join("test/lib/test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.inflector.inflect "cli" => "CLI"
            loader.tag = File.basename __FILE__, ".rb"
            loader.push_dir __dir__
            loader.setup
          end

          # Main namespace.
          module Test
            def self.loader registry = Zeitwerk::Registry
                @loader ||= registry.loaders.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
          end

          end
        CONTENT
      end
    end

    context "when enabled with dashed project name" do
      let :test_configuration do
        configuration.minimize.merge build_cli: true,
                                     build_refinements: true,
                                     build_rspec: true,
                                     build_zeitwerk: true,
                                     project_name: "demo-test"
      end

      it "builds nested executable" do
        expect(temp_dir.join("demo-test/exe/demo-test").read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "demo/test"

          Demo::Test::CLI::Shell.new.call
        CONTENT
      end

      it "adds CLI inflection" do
        expect(temp_dir.join("demo-test/lib/demo/test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.inflector.inflect "cli" => "CLI"
            loader.tag = "demo-test"
            loader.push_dir "\#{__dir__}/.."
            loader.setup
          end

          module Demo
            # Main namespace.
            module Test
              def self.loader registry = Zeitwerk::Registry
                  @loader ||= registry.loaders.find { |loader| loader.tag == "demo-test" }
            end

            end
          end
        CONTENT
      end

      it "builds application container with nested project path to gemspec" do
        expect(temp_dir.join("demo-test/lib/demo/test/container.rb").read).to include(
          %(Spek::Loader.call "\#{__dir__}/../../../demo-test.gemspec")
        )
      end

      it "builds RSpec CLI shell spec" do
        expect(temp_dir.join("demo-test/spec/lib/demo/test/cli/shell_spec.rb").read).to eq(
          fixtures_root.join("spec/lib/cli/shell_dash_proof.rb").read
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
