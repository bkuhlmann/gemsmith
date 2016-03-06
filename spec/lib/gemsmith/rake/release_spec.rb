# frozen_string_literal: true

require "spec_helper"
require "gemsmith/rake/release"

RSpec.describe Gemsmith::Rake::Release, :temp_dir do
  let(:fixtures_dir) { File.join File.dirname(__FILE__), "..", "..", "..", "support", "fixtures" }
  let(:gem_credentials_path) { File.join temp_dir, "credentials" }
  let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
  let(:gem_spec) { Gemsmith::Wrappers::GemSpec.new gem_spec_path }
  let(:gem_config) { Gem::ConfigFile.new [] }
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
  before do
    allow(gem_config).to receive(:credentials_path).and_return(File.join(Dir.pwd, "tmp", "rspec", "credentials"))
  end

  describe "#push" do
    context "with RubyGems credentials" do
      before do
        File.open(gem_credentials_path, "w") { |file| file.write ":rubygems_api_key: ABC" }
        FileUtils.chmod 0600, gem_credentials_path
      end

      shared_examples_for "a standard setup" do
        it "doesn't print errors" do
          subject.push
          expect(shell).to_not have_received(:error)
        end

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
        it_behaves_like "a standard setup"
      end

      context "without gemspec metadata" do
        let(:gem_spec_path) { File.join fixtures_dir, "tester-no_metadata.gemspec" }
        it_behaves_like "a standard setup"
      end
    end

    context "with custom gem credentials" do
      before do
        File.open(gem_credentials_path, "w") { |file| file.write ":test: TEST" }
        FileUtils.chmod 0600, gem_credentials_path
      end

      context "with custom gemspec metadata" do
        let(:gem_spec_path) { File.join fixtures_dir, "tester-custom_metadata.gemspec" }

        it "doesn't print errors" do
          subject.push
          expect(shell).to_not have_received(:error)
        end

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

        it "prints invalid credential error" do
          subject.push
          message = %(Invalid credential (#{gem_credentials_path}): :rubygems_api_key: "".)

          expect(shell).to have_received(:error).with(message)
        end

        it "doesn't push gem to gem server" do
          subject.push
          expect(kernel).to_not have_received(:system)
        end

        it "doesn't print successful gem push message" do
          subject.push
          expect(shell).to_not have_received(:confirm)
        end

        it "answers false" do
          expect(subject.push).to eq(false)
        end
      end
    end

    context "without gem credentials" do
      it "prints file load error" do
        subject.push
        expect(shell).to have_received(:error).with("Unable to load gem credentials: #{gem_credentials_path}.")
      end

      it "doesn't push gem to gem server" do
        subject.push
        expect(kernel).to_not have_received(:system)
      end

      it "doesn't print successful gem push message" do
        subject.push
        expect(shell).to_not have_received(:confirm)
      end

      it "answers false" do
        expect(subject.push).to eq(false)
      end
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
