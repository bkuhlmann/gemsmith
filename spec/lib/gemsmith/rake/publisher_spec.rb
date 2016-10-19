# frozen_string_literal: true

require "spec_helper"
require "gemsmith/rake/publisher"

RSpec.describe Gemsmith::Rake::Publisher, :temp_dir do
  let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
  let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
  let(:gem_spec) { Gemsmith::Gem::Specification.new gem_spec_path }
  let(:gem_config) { instance_spy Gemsmith::Configuration }
  let :credentials do
    instance_spy Gemsmith::Credentials, key: gem_spec.allowed_push_key.to_sym, url: gem_spec.allowed_push_host
  end
  let(:publisher) { instance_spy Milestoner::Publisher }
  let(:shell) { instance_spy Bundler::UI::Shell }
  let(:kernel) { class_spy Kernel }
  subject do
    described_class.new gem_spec: gem_spec,
                        gem_config: gem_config,
                        publisher: publisher,
                        shell: shell,
                        kernel: kernel
  end
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
      let(:command) { %(gem push "pkg/tester-0.1.0.gem" --key "rubygems" --host "https://rubygems.org") }

      it "pushes gem to gem server" do
        subject.push
        expect(kernel).to have_received(:system).with(command)
      end

      it "prints successful gem push message" do
        subject.push
        expect(shell).to have_received(:confirm).with("Pushed tester-0.1.0.gem to https://rubygems.org.")
      end
    end

    context "with RubyGems gemspec metadata" do
      let(:gem_spec_path) { File.join fixtures_dir, "tester-only_ruby_gems_metadata.gemspec" }
      let(:pushed) { true }

      it_behaves_like "a default setup"
    end

    context "with custom gemspec metadata" do
      let(:gem_spec_path) { File.join fixtures_dir, "tester-custom_metadata.gemspec" }
      let(:pushed) { true }
      let(:command) { %(gem push "pkg/tester-0.1.0.gem" --key "test" --host "https://www.test.com") }

      it "pushes gem to gem server" do
        subject.push
        expect(kernel).to have_received(:system).with(command)
      end

      it "prints successful gem push message" do
        subject.push
        expect(shell).to have_received(:confirm).with("Pushed tester-0.1.0.gem to https://www.test.com.")
      end
    end

    context "without gemspec metadata" do
      let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
      let(:pushed) { true }

      it_behaves_like "a default setup"
    end

    context "when push fails" do
      subject { described_class.new gem_spec: gem_spec, publisher: publisher, shell: shell }
      before { allow(Kernel).to receive(:system).and_return(false) }

      it "prints failure message" do
        subject.push
        message = "Failed pushing tester-0.1.0.gem to https://rubygems.org. Check gemspec and gem credential settings."

        expect(shell).to have_received(:error).with(message)
      end

      it "answers false" do
        expect(subject.push).to eq(false)
      end
    end
  end

  describe "#publish" do
    let(:signed) { false }
    let(:gem_config) { instance_spy Gemsmith::Configuration, publish_sign?: signed }
    before { allow(subject).to receive(:push).and_return(true) }

    context "with unsigned version tag" do
      before { subject.publish }

      it "publishes unsigned gem" do
        expect(publisher).to have_received(:publish).with("0.1.0", sign: false)
      end

      it "pushes gem" do
        expect(subject).to have_received(:push)
      end
    end

    context "with signed version tag" do
      let(:signed) { true }
      before { subject.publish }

      it "publishes signed gem" do
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
  end

  describe "#sign" do
    let(:gem_config) { instance_spy Gemsmith::Configuration, publish_sign?: signed }

    context "when gem configuration enables version signing" do
      let(:signed) { false }

      it "answers false" do
        expect(subject.signed?).to eq(false)
      end
    end

    context "when gem configuration disabled version signing" do
      let(:signed) { true }

      it "answers true" do
        expect(subject.signed?).to eq(true)
      end
    end
  end
end
