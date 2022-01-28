# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Packager do
  using Refinements::Pathnames

  subject(:packager) { described_class.new }

  include_context "with application container"

  before { container.stub :executor, Open3 }

  describe "#call" do
    before do
      Bundler.root
             .join("spec/support/fixtures/gemsmith-test.gemspec")
             .copy temp_dir.join("gemsmith-test.gemspec")
    end

    it "builds gem when successful" do
      temp_dir.change_dir do
        packager.call specification
        expect(temp_dir.join("gemsmith-test-0.0.0.gem").exist?).to eq(true)
      end
    end

    it "answers specification when success" do
      temp_dir.change_dir do
        result = packager.call specification
        expect(result.success).to eq(specification)
      end
    end

    context "with failure" do
      subject(:packager) { described_class.new command: }

      let(:command) { instance_double Gem::CommandManager }

      before { allow(command).to receive(:run).and_raise(Gem::Exception, "Danger!") }

      it "doesn't build gem" do
        temp_dir.change_dir do
          packager.call specification
          expect(Pathname("gemsmith-test-0.0.0.gem").exist?).to eq(false)
        end
      end

      it "answers error message" do
        temp_dir.change_dir do
          result = packager.call specification
          expect(result.failure).to eq("Danger!")
        end
      end
    end
  end
end
