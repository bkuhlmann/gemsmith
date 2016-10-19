# frozen_string_literal: true

require "spec_helper"
require "rake"
require "gemsmith/rake/tasks"

RSpec.describe Gemsmith::Rake::Tasks do
  subject { described_class.new }
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

    it "installs doc task" do
      expect(Rake::Task.task_defined?("doc")).to eq(true)
    end

    it "installs clean task" do
      expect(Rake::Task.task_defined?(:clean)).to eq(true)
    end

    it "installs validate task" do
      expect(Rake::Task.task_defined?(:validate)).to eq(true)
    end

    it "installs build task" do
      expect(Rake::Task.task_defined?(:build)).to eq(true)
    end

    it "installs publish task" do
      expect(Rake::Task.task_defined?(:publish)).to eq(true)
    end
  end

  describe "rake tasks" do
    let(:builder) { instance_spy Gemsmith::Rake::Builder }
    let(:publisher) { instance_spy Gemsmith::Rake::Publisher }
    before do
      allow(Gemsmith::Rake::Builder).to receive(:new).and_return(builder)
      allow(Gemsmith::Rake::Publisher).to receive(:new).and_return(publisher)
      subject.install
    end

    describe "rake doc" do
      it "updates README" do
        Rake::Task["doc"].invoke
        expect(builder).to have_received(:doc)
      end
    end

    describe "rake clean" do
      it "cleans gem package" do
        Rake::Task[:clean].invoke
        expect(builder).to have_received(:clean)
      end
    end

    describe "rake validate" do
      it "validates gem build" do
        Rake::Task[:validate].invoke
        expect(builder).to have_received(:validate)
      end
    end

    describe "rake build" do
      it "invokes clean task prerequisite" do
        Rake::Task[:build].invoke
        expect(builder).to have_received(:clean)
      end

      it "invokes doc task prerequisite" do
        Rake::Task[:build].invoke
        expect(builder).to have_received(:doc)
      end

      it "invokes validate task prerequisite" do
        Rake::Task[:build].invoke
        expect(builder).to have_received(:validate)
      end
    end

    describe "rake build" do
      it "has prerequisites" do
        expect(Rake::Task[:build].prerequisites).to contain_exactly("clean", "doc", "validate")
      end

      it "builds gem package" do
        Rake::Task[:build].invoke
        expect(builder).to have_received(:build)
      end
    end

    describe "rake install" do
      it "has prerequisites" do
        expect(Rake::Task[:install].prerequisites).to contain_exactly("build")
      end

      it "builds gem package" do
        Rake::Task[:install].invoke
        expect(builder).to have_received(:install)
      end
    end

    describe "rake publish" do
      it "has prerequisites" do
        expect(Rake::Task[:publish].prerequisites).to contain_exactly("build")
      end

      it "publishes signed release" do
        Rake::Task[:publish].invoke
        expect(publisher).to have_received(:publish)
      end
    end
  end
end
