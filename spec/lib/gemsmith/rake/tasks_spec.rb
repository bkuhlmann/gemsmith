# frozen_string_literal: true

require "spec_helper"
require "rake"
require "gemsmith/rake/tasks"

RSpec.describe Gemsmith::Rake::Tasks do
  subject { described_class.new }
  before do
    Rake::Task.clear
    Rake::Task.define_task :build
    Rake::Task.define_task :release
    Rake::Task.define_task "release:guard_clean"
    Rake::Task.define_task "release:rubygem_push"
  end

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

    it "installs publish task" do
      expect(Rake::Task.task_defined?(:publish)).to eq(true)
    end
  end

  describe "rake tasks" do
    let(:builder) { instance_spy Gemsmith::Rake::Builder }
    let(:release) { instance_spy Gemsmith::Rake::Release }
    before do
      allow(Gemsmith::Rake::Builder).to receive(:new).and_return(builder)
      allow(Gemsmith::Rake::Release).to receive(:new).and_return(release)
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

    describe "rake release" do
      it "has prerequisites" do
        expect(Rake::Task[:release].prerequisites).to contain_exactly("build")
      end

      it "publishes unsigned release" do
        Rake::Task[:release].invoke
        expect(release).to have_received(:publish).with(sign: false)
      end
    end

    describe "rake publish" do
      it "has prerequisites" do
        expect(Rake::Task[:publish].prerequisites).to contain_exactly("build")
      end

      it "publishes signed release" do
        Rake::Task[:publish].invoke
        expect(release).to have_received(:publish)
      end
    end
  end
end
