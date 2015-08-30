require "spec_helper"

describe Gemsmith::Skeletons::RailsSkeleton, :temp_dir do
  let(:gem_name) { "tester" }
  let(:gem_dir) { File.join temp_dir, gem_name }
  let(:options) { {gem_name: gem_name} }
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir, gem_name: gem_name, template_options: options }
  subject { described_class.new cli }
  before { FileUtils.mkdir gem_dir }

  describe "#create_engine" do
    before do
      allow(subject).to receive(:system)
      subject.create_engine
    end

    it "creates engine file" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/%gem_name%/engine.rb.tt", options)
    end

    it "generates Rails engine" do
      command = "rails plugin new --skip tester"
      options = "--skip-bundle --skip-test-unit --skip-keeps --skip-git --mountable --dummy-path=spec/dummy"
      command_and_options = "#{command} #{options}"

      expect(subject).to have_received(:system).with(command_and_options)
    end

    it "removes generated application helper file" do
      expect(cli).to have_received(:remove_file).with("tester/app/helpers/tester/application_helper.rb", options)
    end

    it "removes generated version file" do
      expect(cli).to have_received(:remove_file).with("tester/lib/tester/version.rb", options)
    end

    it "removes generated license file" do
      expect(cli).to have_received(:remove_file).with("tester/MIT-LICENSE", options)
    end

    it "removes generated readme file" do
      expect(cli).to have_received(:remove_file).with("tester/README.rdoc", options)
    end
  end

  describe "#create_generator_files" do
    before { subject.create_generator_files }

    it "creates install generator script" do
      template = "%gem_name%/lib/generators/%gem_name%/install/install_generator.rb.tt"
      expect(cli).to have_received(:template).with(template, options)
    end

    it "creates install generator usage documentation" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/generators/%gem_name%/install/USAGE.tt", options)
    end

    it "creates upgrade generator script" do
      template = "%gem_name%/lib/generators/%gem_name%/upgrade/upgrade_generator.rb.tt"
      expect(cli).to have_received(:template).with(template, options)
    end

    it "creates upgrade generator usage documentation" do
      expect(cli).to have_received(:template).with("%gem_name%/lib/generators/%gem_name%/upgrade/USAGE.tt", options)
    end
  end

  describe "#create_travis_gemfiles" do
    context "when Travis CI is enabled" do
      let(:options) { {travis: true} }

      it "creates Rails gemfile" do
        subject.create_travis_gemfiles
        expect(cli).to have_received(:template).with("%gem_name%/gemfiles/rails-4.1.x.gemfile.tt", options)
      end
    end

    context "when Travis CI is disabled" do
      let(:options) { {travis: false} }

      it "does not create Rails gemfile" do
        subject.create_travis_gemfiles
        expect(cli).to_not have_received(:template)
      end
    end
  end

  describe "#create" do
    before do
      allow(subject).to receive(:create_engine)
      allow(subject).to receive(:create_generator_files)
      allow(subject).to receive(:create_travis_gemfiles)
    end

    it "creates skeleton", :aggregate_failures do
      subject.create

      expect(subject).to have_received(:create_engine)
      expect(subject).to have_received(:create_generator_files)
      expect(subject).to have_received(:create_travis_gemfiles)
    end
  end
end
