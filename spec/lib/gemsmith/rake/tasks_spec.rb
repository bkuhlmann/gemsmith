# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Rake::Tasks do
  subject(:tasks) { described_class.new gem_spec: gem_spec, builder: builder, publisher: publisher }

  let(:gem_spec) { instance_spy Gemsmith::Gem::Specification }
  let(:builder) { instance_spy Gemsmith::Rake::Builder }
  let(:publisher) { instance_spy Gemsmith::Rake::Publisher }

  before { Rake::Task.clear }

  describe ".setup" do
    subject(:tasks) { instance_spy described_class }

    before { allow(described_class).to receive(:new).and_return(tasks) }

    it "installs rake tasks" do
      described_class.setup
      expect(tasks).to have_received(:install)
    end
  end

  describe "#install" do
    before { tasks.install }

    context "with toc task" do
      it "updates README" do
        Rake::Task["toc"].invoke
        expect(builder).to have_received(:toc)
      end
    end

    context "with clean task" do
      it "cleans gem artifacts" do
        Rake::Task[:clean].invoke
        expect(builder).to have_received(:clean)
      end
    end

    context "with validate task" do
      it "validates gem build" do
        Rake::Task[:validate].invoke
        expect(builder).to have_received(:validate)
      end
    end

    context "with build task" do
      it "invokes prerequisites" do
        expect(Rake::Task[:build].prerequisites).to contain_exactly("clean", "toc", "validate")
      end

      it "builds gem package" do
        Rake::Task[:build].invoke
        expect(builder).to have_received(:build).with(gem_spec)
      end
    end

    context "with install task" do
      it "invokes prerequisites" do
        expect(Rake::Task[:install].prerequisites).to contain_exactly("build")
      end

      it "installs gem package" do
        Rake::Task[:install].invoke
        expect(builder).to have_received(:install).with(gem_spec)
      end
    end

    context "with publish task" do
      it "invokes prerequisites" do
        expect(Rake::Task[:publish].prerequisites).to contain_exactly("build")
      end

      it "publishes gem package" do
        Rake::Task[:publish].invoke
        expect(publisher).to have_received(:publish)
      end
    end
  end
end
