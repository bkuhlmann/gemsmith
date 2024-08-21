# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::CLI do
  using Refinements::Struct
  using Refinements::Pathname

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    let(:fixtures_root) { SPEC_ROOT.join "support/fixtures" }

    context "when enabled" do
      before do
        settings.merge! settings.minimize.merge(
          build_cli: true,
          build_refinements: true,
          build_zeitwerk: true
        )

        Rubysmith::Builders::Core.new(settings:, logger:).call
        Rubysmith::Builders::Bundler.new(settings:, logger:).call
      end

      it "builds executable" do
        builder.call

        expect(temp_dir.join("test/exe/test").read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "test"

          Test::CLI::Shell.new.call
        CONTENT
      end

      it "sets executable as executable" do
        builder.call
        expect(temp_dir.join("test/exe/test").stat.mode).to eq(33261)
      end

      it "builds CLI shell" do
        builder.call

        expect(temp_dir.join("test/lib/test/cli/shell.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/cli/shell.rb").read
        )
      end

      it "builds configuration defaults" do
        builder.call
        expect(temp_dir.join("test/lib/test/configuration/defaults.yml").read).to eq(
          %(todo: "Add your own attributes here."\n)
        )
      end

      it "builds configuration contract" do
        builder.call

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
        builder.call

        expect(temp_dir.join("test/lib/test/configuration/model.rb").read).to eq(<<~CONTENT)
          module Test
            module Configuration
              # Defines the configuration model for use throughout the gem.
              Model = Struct.new
            end
          end
        CONTENT
      end

      it "builds application container" do
        builder.call

        expect(temp_dir.join("test/lib/test/container.rb").read).to eq(
          SPEC_ROOT.join("support/fixtures/lib/container.rb").read
        )
      end

      it "builds application import" do
        builder.call

        expect(temp_dir.join("test/lib/test/import.rb").read).to eq(<<~CONTENT)
          require "infusible"

          module Test
            Import = Infusible[Container]
          end
        CONTENT
      end
    end

    context "when enabled without Zeitwerk" do
      before do
        settings.merge! settings.minimize.merge(build_cli: true)

        Rubysmith::Builders::Core.new(settings:, logger:).call
        Rubysmith::Builders::Bundler.new(settings:, logger:).call
      end

      it "builds requirements" do
        builder.call

        expect(temp_dir.join("test/lib/test.rb").read).to eq(<<~CONTENT)
          require "demo/configuration/contract"
          require "demo/configuration/model"
          require "demo/container"
          require "demo/import"

          require "demo/cli/shell"

          # Main namespace.
          module Test
          end
        CONTENT
      end
    end

    context "when enabled with RSpec" do
      before do
        settings.merge! settings.minimize.merge(
          build_cli: true,
          build_refinements: true,
          build_rspec: true,
          build_zeitwerk: true
        )

        Rubysmith::Builders::Core.new(settings:, logger:).call
        Rubysmith::Builders::Bundler.new(settings:, logger:).call
      end

      it "builds RSpec CLI shell spec" do
        builder.call

        expect(temp_dir.join("test/spec/lib/test/cli/shell_spec.rb").read).to eq(
          fixtures_root.join("spec/lib/cli/shell_with_refinements_proof.rb").read
        )
      end

      it "builds RSpec application container shared context" do
        template_path = temp_dir.join(
          "test/spec/support/shared_contexts/application_dependencies.rb"
        )
        fixture_path = fixtures_root.join "spec/support/shared_contexts/application_dependencies.rb"

        builder.call

        expect(template_path.read).to eq(fixture_path.read)
      end
    end

    context "when enabled with RSpec but without Refinements" do
      before do
        settings.merge! settings.minimize.merge(
          build_cli: true,
          build_rspec: true,
          build_zeitwerk: true
        )

        Rubysmith::Builders::Core.new(settings:, logger:).call
        Rubysmith::Builders::Bundler.new(settings:, logger:).call
      end

      it "builds RSpec CLI shell spec" do
        builder.call

        expect(temp_dir.join("test/spec/lib/test/cli/shell_spec.rb").read).to eq(
          fixtures_root.join("spec/lib/cli/shell_without_refinements_proof.rb").read
        )
      end

      it "builds RSpec application container shared context" do
        template_path = temp_dir.join(
          "test/spec/support/shared_contexts/application_dependencies.rb"
        )

        builder.call

        expect(template_path.read).to eq(<<~CONTENT)
          RSpec.shared_context "with application dependencies" do

            let(:settings) { Test::Container[:settings] }
            let(:logger) { Cogger.new id: "test", io: StringIO.new, level: :debug }
            let(:io) { StringIO.new }

            before { Demo::Container.stub! logger:, io: }

            after { Test::Container.restore }
          end
        CONTENT
      end
    end

    context "when enabled with simple project name" do
      before do
        settings.merge! settings.minimize.merge(
          build_cli: true,
          build_refinements: true,
          build_zeitwerk: true
        )

        Rubysmith::Builders::Core.new(settings:, logger:).call
        Rubysmith::Builders::Bundler.new(settings:, logger:).call
      end

      it "adds CLI inflection" do
        builder.call

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
      before do
        settings.merge! settings.minimize.merge(
          build_cli: true,
          build_refinements: true,
          build_rspec: true,
          build_zeitwerk: true,
          project_name: "demo-test"
        )

        Rubysmith::Builders::Core.new(settings:, logger:).call
        Rubysmith::Builders::Bundler.new(settings:, logger:).call
      end

      it "builds nested executable" do
        builder.call

        expect(temp_dir.join("demo-test/exe/demo-test").read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "demo/test"

          Demo::Test::CLI::Shell.new.call
        CONTENT
      end

      it "adds CLI inflection" do
        builder.call

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
        builder.call

        expect(temp_dir.join("demo-test/lib/demo/test/container.rb").read).to include(
          %(Spek::Loader.call "\#{__dir__}/../../../demo-test.gemspec")
        )
      end

      it "builds RSpec CLI shell spec" do
        builder.call

        expect(temp_dir.join("demo-test/spec/lib/demo/test/cli/shell_spec.rb").read).to eq(
          fixtures_root.join("spec/lib/cli/shell_dash_proof.rb").read
        )
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build executable" do
        builder.call
        expect(temp_dir.join("test/exe/test").exist?).to be(false)
      end

      it "doesn't build lib folder" do
        builder.call
        expect(temp_dir.join("test/lib").exist?).to be(false)
      end

      it "doesn't build spec folder" do
        builder.call
        expect(temp_dir.join("test/spec").exist?).to be(false)
      end

      it "doesn't build gemfile" do
        builder.call
        expect(temp_dir.join("test/Gemfile").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
