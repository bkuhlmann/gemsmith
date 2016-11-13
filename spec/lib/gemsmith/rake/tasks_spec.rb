# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Rake::Tasks do
  let(:gem_spec) { instance_spy Gemsmith::Gem::Specification }
  let(:builder) { instance_spy Gemsmith::Rake::Builder }
  let(:publisher) { instance_spy Gemsmith::Rake::Publisher }
  subject { described_class.new gem_spec: gem_spec, builder: builder, publisher: publisher }
  before { Rake::Task.clear }

  describe ".setup" do
    let(:tasks) { instance_spy described_class }
    before { allow(described_class).to receive(:new).and_return(tasks) }

    it "installs rake tasks" do
      described_class.setup
      expect(tasks).to have_received(:install)
    end
  end

  describe "#install" do
    before { subject.install }

    context "rake doc" do
      it "updates README" do
        Rake::Task["doc"].invoke
        expect(builder).to have_received(:doc)
      end
    end

    context "rake clean" do
      it "cleans gem artifacts" do
        Rake::Task[:clean].invoke
        expect(builder).to have_received(:clean)
      end
    end

    context "rake validate" do
      it "validates gem build" do
        Rake::Task[:validate].invoke
        expect(builder).to have_received(:validate)
      end
    end

    context "rake build" do
      it "invokes prerequisites" do
        expect(Rake::Task[:build].prerequisites).to contain_exactly("clean", "doc", "validate")
      end

      it "builds gem package" do
        Rake::Task[:build].invoke
        expect(builder).to have_received(:build).with(gem_spec)
      end
    end

    context "rake install" do
      it "invokes prerequisites" do
        expect(Rake::Task[:install].prerequisites).to contain_exactly("build")
      end

      it "installs gem package" do
        Rake::Task[:install].invoke
        expect(builder).to have_received(:install).with(gem_spec)
      end
    end

    context "rake publish" do
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
