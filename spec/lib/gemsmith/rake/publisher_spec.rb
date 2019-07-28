# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Rake::Publisher, :temp_dir do
  subject :publisher do
    described_class.new gem_spec: gem_spec,
                        gem_config: gem_config,
                        publisher: milestone_publisher,
                        shell: shell,
                        kernel: kernel
  end

  let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
  let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
  let(:gem_spec) { Gemsmith::Gem::Specification.new gem_spec_path }
  let(:signed) { false }
  let(:gem_config) { {gem: {name: "tester"}, publish: {sign: signed}} }

  let :credentials do
    instance_spy Gemsmith::Credentials,
                 key: gem_spec.allowed_push_key.to_sym,
                 url: gem_spec.allowed_push_host
  end

  let(:milestone_publisher) { instance_spy Milestoner::Publisher }
  let(:shell) { instance_spy Bundler::UI::Shell }
  let(:kernel) { class_spy Kernel }

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

  shared_examples_for "push" do
    shared_examples_for "a default setup" do
      let :command do
        %(gem push "pkg/tester-0.1.0.gem" --key "rubygems" --host "https://rubygems.org")
      end

      it "pushes gem to gem server" do
        expect(kernel).to have_received(:system).with(command)
      end

      it "prints successful gem push message" do
        output = "Pushed tester-0.1.0.gem to https://rubygems.org."
        expect(shell).to have_received(:confirm).with(output)
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
      let :command do
        %(gem push "pkg/tester-0.1.0.gem" --key "test" --host "https://www.test.com")
      end

      it "pushes gem to gem server" do
        expect(kernel).to have_received(:system).with(command)
      end

      it "prints successful gem push message" do
        output = "Pushed tester-0.1.0.gem to https://www.test.com."

        expect(shell).to have_received(:confirm).with(output)
      end
    end

    context "without gemspec metadata" do
      let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
      let(:pushed) { true }

      it_behaves_like "a default setup"
    end

    context "when push fails" do
      subject :publisher do
        described_class.new gem_spec: gem_spec, publisher: milestone_publisher, shell: shell
      end

      before { allow(Kernel).to receive(:system).and_return(false) }

      it "prints failure message" do
        message = "Failed pushing tester-0.1.0.gem to https://rubygems.org. " \
                  "Check gemspec and gem credential settings."

        expect(shell).to have_received(:error).with(message)
      end
    end
  end

  describe "#push" do
    before { publisher.push }

    it_behaves_like "push"

    context "when push fails" do
      subject :publisher do
        described_class.new gem_spec: gem_spec, publisher: milestone_publisher, shell: shell
      end

      before { allow(Kernel).to receive(:system).and_return(false) }

      it "answers false" do
        expect(publisher.push).to eq(false)
      end
    end
  end

  describe "#publish" do
    let(:version) { Versionaire::Version "0.1.0" }

    context "with unsigned version tag" do
      before { publisher.publish }

      it "publishes unsigned gem" do
        expect(milestone_publisher).to have_received(:publish).with(version, sign: false)
      end

      it_behaves_like "push"
    end

    context "with signed version tag" do
      let(:signed) { true }

      before { publisher.publish }

      it "publishes signed gem" do
        expect(milestone_publisher).to have_received(:publish).with(version, sign: true)
      end

      it_behaves_like "push"
    end

    context "with Milestoner error" do
      before do
        allow(milestone_publisher).to receive(:publish).and_raise(Milestoner::Errors::Base, "test")
        Dir.chdir(temp_dir) { publisher.publish }
      end

      it "prints error" do
        expect(shell).to have_received(:error)
      end

      it "does not push gem" do
        expect(kernel).not_to have_received(:system)
      end
    end
  end

  describe "#sign" do
    context "when gem configuration enables version signing" do
      it "answers false" do
        expect(publisher.signed?).to eq(false)
      end
    end

    context "when gem configuration disabled version signing" do
      let(:signed) { true }

      it "answers true" do
        expect(publisher.signed?).to eq(true)
      end
    end
  end
end
