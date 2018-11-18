# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Engine, :temp_dir do
  subject(:engine) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester", path: "tester"}} }

  describe "#rails?" do
    let(:command) { "command -v rails > /dev/null" }

    context "when Rails exists" do
      before { allow(cli).to receive(:run).with(command).and_return(true) }

      it "answers true" do
        expect(engine.rails?).to eq(true)
      end
    end

    context "when Rails doesn't exist" do
      before { allow(cli).to receive(:run).with(command).and_return(false) }

      it "answers false" do
        expect(engine.rails?).to eq(false)
      end
    end
  end

  describe "install_rails" do
    let(:prompt) { "Ruby on Rails is not installed. Would you like it installed (y/n)?" }

    before do
      allow(engine).to receive(:rails?).and_return(rails)
      allow(cli).to receive(:yes?).with(prompt).and_return(create_rails)
    end

    context "when Rails exists" do
      let(:rails) { true }
      let(:create_rails) { false }

      it "does not install Rails" do
        expect(cli).not_to have_received(:run)
      end
    end

    context "when Rails does not exist and Rails install is aborted" do
      let(:rails) { false }
      let(:create_rails) { false }

      it "does not install Rails" do
        expect(cli).not_to have_received(:run)
      end
    end

    context "when Rails does not exist and Rails install is accepted" do
      let(:rails) { false }
      let(:create_rails) { true }

      it "does not install Rails" do
        engine.install_rails
        expect(cli).to have_received(:run).with("gem install rails")
      end
    end
  end

  describe "#create_engine" do
    let :options do
      %w[
        --skip-git
        --skip-bundle
        --skip-keeps
        --skip-turbolinks
        --skip-spring
        --skip-test
        --mountable
        --dummy-path=spec/dummy
      ]
    end

    before { engine.create_engine }

    it "creates engine file" do
      template = "%gem_name%/lib/%gem_path%/engine.rb.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end

    it "generates engine" do
      command = "rails plugin new --skip tester"
      command_and_options = %(#{command} #{options.join " "})

      expect(cli).to have_received(:run).with(command_and_options)
    end
  end

  describe "#create_generator_files" do
    before { engine.create_generator_files }

    it "creates install generator script" do
      template = "%gem_name%/lib/generators/%gem_path%/install/install_generator.rb.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end

    it "creates install generator usage documentation" do
      template = "%gem_name%/lib/generators/%gem_path%/install/USAGE.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end

    it "creates upgrade generator script" do
      template = "%gem_name%/lib/generators/%gem_path%/upgrade/upgrade_generator.rb.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end

    it "creates upgrade generator usage documentation" do
      template = "%gem_name%/lib/generators/%gem_path%/upgrade/USAGE.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end
  end

  describe "#stub_assets" do
    before { engine.stub_assets }

    it "stubs JavaScript application file" do
      command = %(printf "%s" > "tester/app/assets/javascripts/tester/application.js")
      expect(cli).to have_received(:run).with(command)
    end

    it "stubs stylesheet application file" do
      command = %(printf "%s" > "tester/app/assets/stylesheets/tester/application.css")
      expect(cli).to have_received(:run).with(command)
    end
  end

  describe "#remove_files" do
    before { engine.remove_files }

    it "removes generated application helper file" do
      file = "tester/app/helpers/tester/application_helper.rb"
      expect(cli).to have_received(:remove_file).with(file, configuration)
    end

    it "removes generated version file" do
      expect(cli).to have_received(:remove_file).with("tester/lib/tester/version.rb", configuration)
    end

    it "removes generated license file" do
      expect(cli).to have_received(:remove_file).with("tester/MIT-LICENSE", configuration)
    end

    it "removes generated readme file" do
      expect(cli).to have_received(:remove_file).with("tester/README.rdoc", configuration)
    end
  end

  describe "#run" do
    before do
      allow(engine).to receive(:install_rails)
      allow(engine).to receive(:create_engine)
      allow(engine).to receive(:create_generator_files)
      allow(engine).to receive(:stub_assets)
      allow(engine).to receive(:remove_files)
    end

    context "when engine enabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {engine: true}} }

      it "generates Rails support", :aggregate_failures do
        engine.run

        expect(engine).to have_received(:install_rails)
        expect(engine).to have_received(:create_engine)
        expect(engine).to have_received(:create_generator_files)
        expect(engine).to have_received(:stub_assets)
        expect(engine).to have_received(:remove_files)
      end
    end

    context "when engine disabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {engine: false}} }

      it "does not generate Rails support", :aggregate_failures do
        engine.run

        expect(engine).not_to have_received(:install_rails)
        expect(engine).not_to have_received(:create_engine)
        expect(engine).not_to have_received(:create_generator_files)
        expect(engine).not_to have_received(:stub_assets)
        expect(engine).not_to have_received(:remove_files)
      end
    end
  end
end
