# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Documentation, :temp_dir do
  subject(:documentation) { described_class.new cli, configuration: configuration }

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }

  describe "#create_files" do
    before { documentation.create_files }

    it "creates readme" do
      expect(cli).to have_received(:template).with("%gem_name%/README.md.tt", configuration)
    end

    it "creates contributing guidelines" do
      expect(cli).to have_received(:template).with("%gem_name%/CONTRIBUTING.md.tt", configuration)
    end

    it "creates code of conduct" do
      expect(cli).to have_received(:template).with(
        "%gem_name%/CODE_OF_CONDUCT.md.tt",
        configuration
      )
    end

    it "creates software license" do
      expect(cli).to have_received(:template).with("%gem_name%/LICENSE.md.tt", configuration)
    end

    it "creates change log" do
      expect(cli).to have_received(:template).with("%gem_name%/CHANGES.md.tt", configuration)
    end
  end

  describe "#update_readme" do
    let(:tocer) { instance_spy Tocer::Writer }
    let(:file) { File.join cli.destination_root, cli.gem_name, "README.md" }

    before do
      allow(Tocer::Writer).to receive(:new).and_return(tocer)
      documentation.update_readme
    end

    it "updates readme" do
      expect(tocer).to have_received(:call)
    end
  end

  describe "#run" do
    before do
      # rubocop:disable RSpec/SubjectStub
      allow(documentation).to receive(:create_files)
      allow(documentation).to receive(:update_readme)
      # rubocop:enable RSpec/SubjectStub
    end

    it "creates files" do
      documentation.run
      expect(documentation).to have_received(:create_files)
    end

    it "creates updates readme" do
      documentation.run
      expect(documentation).to have_received(:update_readme)
    end
  end
end
