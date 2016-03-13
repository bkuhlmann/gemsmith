# frozen_string_literal: true

require "spec_helper"
require "gemsmith/rake/release"

RSpec.describe Gemsmith::Rake::Release, :temp_dir do
  let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
  let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
  let(:gem_spec) { Gemsmith::Wrappers::GemSpec.new gem_spec_path }
  let :credentials do
    instance_spy Gemsmith::Credentials,
                 key: gem_spec.allowed_push_key.to_sym,
                 url: gem_spec.allowed_push_host
  end
  let(:publisher) { instance_spy Milestoner::Publisher }
  let(:shell) { instance_spy Bundler::UI::Shell }
  let(:kernel) { class_spy Kernel }
  subject { described_class.new gem_spec: gem_spec, publisher: publisher, shell: shell, kernel: kernel }
  before { allow(Gemsmith::Credentials).to receive(:new).and_return(credentials) }

  describe ".gem_spec_path" do
    context "with gemspec" do
      it "answers gemspec path" do
        expect(described_class.gem_spec_path).to end_with("gemsmith.gemspec")
      end
    end

    context "without gemspec" do
      it "an empty string" do
        Dir.chdir temp_dir do
          expect(described_class.gem_spec_path).to eq("")
        end
      end
    end
  end

  describe "#push" do
    shared_examples_for "a default setup" do
      it "pushes gem to gem server" do
        subject.push
        command = %(gem push "pkg/tester-0.1.0.gem" --key "rubygems" --host "https://rubygems.org")

        expect(kernel).to have_received(:system).with(command)
      end

      it "prints successful gem push message" do
        subject.push
        message = "Pushed tester-0.1.0.gem to https://rubygems.org."

        expect(shell).to have_received(:confirm).with(message)
      end

      it "answers true" do
        expect(subject.push).to eq(true)
      end
    end

    context "with RubyGems gemspec metadata" do
      let(:gem_spec_path) { File.join fixtures_dir, "tester-only_ruby_gems_metadata.gemspec" }
      it_behaves_like "a default setup"
    end

    context "with custom gemspec metadata" do
      let(:gem_spec_path) { File.join fixtures_dir, "tester-custom_metadata.gemspec" }

      it "pushes gem to gem server" do
        subject.push
        command = %(gem push "pkg/tester-0.1.0.gem" --key "test" --host "https://www.test.com")

        expect(kernel).to have_received(:system).with(command)
      end

      it "prints successful gem push message" do
        subject.push
        message = "Pushed tester-0.1.0.gem to https://www.test.com."

        expect(shell).to have_received(:confirm).with(message)
      end

      it "answers true" do
        expect(subject.push).to eq(true)
      end
    end

    context "without gemspec metadata" do
      let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
      it_behaves_like "a default setup"
    end
  end

  describe "#publish" do
    before { allow(subject).to receive(:push).and_return(true) }

    context "without Milestoner errors" do
      before { subject.publish }

      it "publishes gem" do
        expect(publisher).to have_received(:publish).with("0.1.0", sign: true)
      end

      it "pushes gem" do
        expect(subject).to have_received(:push)
      end
    end

    context "with Milestoner error" do
      before do
        allow(publisher).to receive(:publish).and_raise(Milestoner::Errors::Base, "test")
        Dir.chdir(temp_dir) { subject.publish }
      end

      it "prints error" do
        expect(shell).to have_received(:error)
      end

      it "does not push gem" do
        expect(subject).to_not have_received(:push)
      end
    end

    context "with unsigned tag" do
      before { subject.publish sign: false }

      it "publishes gem" do
        expect(publisher).to have_received(:publish).with("0.1.0", sign: false)
      end

      it "pushes gem" do
        expect(subject).to have_received(:push)
      end
    end
  end
end
