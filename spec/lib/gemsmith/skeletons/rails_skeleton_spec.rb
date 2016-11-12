# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::RailsSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester", path: "tester"}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#rails?" do
    let(:command) { "command -v rails > /dev/null" }

    context "when Rails exists" do
      before { allow(cli).to receive(:run).with(command).and_return(true) }

      it "answers true" do
        expect(subject.rails?).to eq(true)
      end
    end

    context "when Rails doesn't exist" do
      before { allow(cli).to receive(:run).with(command).and_return(false) }

      it "answers false" do
        expect(subject.rails?).to eq(false)
      end
    end
  end

  describe "install_rails" do
    let(:prompt) { "Ruby on Rails is not installed. Would you like to install it (y/n)?" }
    before do
      allow(subject).to receive(:rails?).and_return(rails)
      allow(cli).to receive(:yes?).with(prompt).and_return(create_rails)
    end

    context "when Rails exists" do
      let(:rails) { true }
      let(:create_rails) { false }

      it "does not install Rails" do
        expect(cli).to_not have_received(:run)
      end
    end

    context "when Rails does not exist and Rails install is aborted" do
      let(:rails) { false }
      let(:create_rails) { false }

      it "does not install Rails" do
        expect(cli).to_not have_received(:run)
      end
    end

    context "when Rails does not exist and Rails install is accepted" do
      let(:rails) { false }
      let(:create_rails) { true }

      it "does not install Rails" do
        subject.install_rails
        expect(cli).to have_received(:run).with("gem install rails")
      end
    end
  end

  describe "#create_engine" do
    before { subject.create_engine }

    it "creates engine file" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_path%/engine.rb.tt", configuration)
    end

    it "generates Rails engine" do
      command = "rails plugin new --skip tester"
      options = "--skip-bundle --skip-test --skip-keeps --skip-git --mountable --dummy-path=spec/dummy"
      command_and_options = "#{command} #{options}"

      expect(cli).to have_received(:run).with(command_and_options)
    end
  end

  describe "#create_generator_files" do
    before { subject.create_generator_files }

    it "creates install generator script" do
      template = "%gem_name%/lib/generators/%gem_path%/install/install_generator.rb.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end

    it "creates install generator usage documentation" do
      template = "%gem_name%/lib/generators/%gem_path%/install/USAGE.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end

    it "creates upgrade generator script" do
      template = "%gem_name%/lib/generators/%gem_path%/upgrade/upgrade_generator.rb.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end

    it "creates upgrade generator usage documentation" do
      template = "%gem_name%/lib/generators/%gem_path%/upgrade/USAGE.tt"
      expect(cli).to have_received(:template).with(template, configuration)
    end
  end

  describe "#create_travis_gemfiles" do
    context "when Travis CI is enabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {travis: true}} }

      it "creates Rails gemfile" do
        subject.create_travis_gemfiles
        template = "%gem_name%/gemfiles/rails-%rails_version%.x.gemfile.tt"
        expect(cli).to have_received(:template).with(template, configuration)
      end
    end

    context "when Travis CI is disabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {travis: false}} }

      it "does not create Rails gemfile" do
        subject.create_travis_gemfiles
        expect(cli).to_not have_received(:template)
      end
    end
  end

  describe "#add_comments" do
    before { subject.add_comments }

    it "adds application controller comment" do
      expect(cli).to have_received(:insert_into_file).with(
        "%gem_name%/app/controllers/%gem_path%/application_controller.rb",
        "  # The application controller.\n",
        before: /.+class.+/
      )
    end

    it "adds application mailer comment" do
      expect(cli).to have_received(:insert_into_file).with(
        "%gem_name%/app/mailers/%gem_path%/application_mailer.rb",
        "  # The application mailer.\n",
        before: /.+class.+/
      )
    end

    it "adds application record comment" do
      expect(cli).to have_received(:insert_into_file).with(
        "%gem_name%/app/models/%gem_path%/application_record.rb",
        "  # The application record.\n",
        before: /.+class.+/
      )
    end
  end

  describe "#remove_files" do
    before { subject.remove_files }

    it "removes generated application helper file" do
      file = "tester/app/helpers/tester/application_helper.rb"
      expect(cli).to have_received(:remove_file).with(file, configuration)
    end

    it "removes generated version file" do
      expect(cli).to have_received(:remove_file).with("tester/lib/tester/version.rb", configuration)
    end

    it "removes generated license file" do
      expect(cli).to have_received(:remove_file).with("tester/MIT-LICENSE", configuration)
    end

    it "removes generated readme file" do
      expect(cli).to have_received(:remove_file).with("tester/README.rdoc", configuration)
    end
  end

  describe "#create" do
    before do
      allow(subject).to receive(:install_rails)
      allow(subject).to receive(:create_engine)
      allow(subject).to receive(:create_generator_files)
      allow(subject).to receive(:create_travis_gemfiles)
      allow(subject).to receive(:add_comments)
      allow(subject).to receive(:remove_files)
    end

    context "when enabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {rails: true}} }

      it "creates skeleton", :aggregate_failures do
        subject.create

        expect(subject).to have_received(:install_rails)
        expect(subject).to have_received(:create_engine)
        expect(subject).to have_received(:create_generator_files)
        expect(subject).to have_received(:create_travis_gemfiles)
        expect(subject).to have_received(:add_comments)
        expect(subject).to have_received(:remove_files)
      end
    end

    context "when disabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {rails: false}} }

      it "does not create skeleton", :aggregate_failures do
        subject.create

        expect(subject).to_not have_received(:install_rails)
        expect(subject).to_not have_received(:create_engine)
        expect(subject).to_not have_received(:create_generator_files)
        expect(subject).to_not have_received(:create_travis_gemfiles)
        expect(subject).to_not have_received(:add_comments)
        expect(subject).to_not have_received(:remove_files)
      end
    end
  end
end
