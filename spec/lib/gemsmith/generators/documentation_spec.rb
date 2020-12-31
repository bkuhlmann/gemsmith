# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Documentation do
  subject(:documentation) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:configuration) { {gem: {name: "tester"}} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }

  describe "#run" do
    let(:tocer) { instance_spy Tocer::Writer }
    let(:file) { cli.destination_root.join cli.gem_name, "README.md" }

    before do
      allow(Tocer::Writer).to receive(:new).and_return(tocer)
      documentation.run
    end

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

    it "add table of contents to readme" do
      expect(tocer).to have_received(:call)
    end
  end
end
