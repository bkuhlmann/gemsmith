# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Engine do
  subject(:engine) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester", path: "tester"}} }

  describe "#run" do
    let :options do
      %w[
        --skip-git
        --skip-bundle
        --skip-keeps
        --skip-turbolinks
        --skip-spring
        --skip-test
        --mountable
        --dummy-path=spec/dummy
      ]
    end

    context "when engine is enabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {engine: true}} }

      it "does not install Rails when Rails exists" do
        allow(cli).to receive(:run).and_return(true)
        engine.run

        expect(cli).not_to have_received(:run).with("gem install rails")
      end

      it "does not install Rails when Rails isn't found and Rails install is aborted" do
        allow(cli).to receive(:run).and_return(false)
        allow(cli).to receive(:yes?).and_return(false)
        engine.run

        expect(cli).not_to have_received(:run).with("gem install rails")
      end

      it "installs Rails when Rails isn't found and install is accepted" do
        allow(cli).to receive(:run).and_return(false)
        allow(cli).to receive(:yes?).and_return(true)
        engine.run

        expect(cli).to have_received(:run).with("gem install rails")
      end

      it "creates engine file" do
        engine.run

        expect(cli).to have_received(:template).with(
          "%gem_name%/lib/%gem_path%/engine.rb.tt",
          configuration
        )
      end

      it "generates engine" do
        engine.run

        expect(cli).to have_received(:run).with(
          %(rails plugin new --skip tester #{options.join " "})
        )
      end

      it "creates install generator script" do
        engine.run

        expect(cli).to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/install/install_generator.rb.tt",
          configuration
        )
      end

      it "creates install generator usage documentation" do
        engine.run

        expect(cli).to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/install/USAGE.tt",
          configuration
        )
      end

      it "creates upgrade generator script" do
        engine.run

        expect(cli).to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/upgrade/upgrade_generator.rb.tt",
          configuration
        )
      end

      it "creates upgrade generator usage documentation" do
        engine.run

        expect(cli).to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/upgrade/USAGE.tt",
          configuration
        )
      end

      it "stubs JavaScript application file" do
        engine.run

        expect(cli).to have_received(:run).with(
          %(printf "%s" > "tester/app/assets/javascripts/tester/application.js")
        )
      end

      it "stubs stylesheet application file" do
        engine.run

        expect(cli).to have_received(:run).with(
          %(printf "%s" > "tester/app/assets/stylesheets/tester/application.css")
        )
      end

      it "removes application helper file" do
        engine.run

        expect(cli).to have_received(:remove_file).with(
          "tester/app/helpers/tester/application_helper.rb",
          configuration
        )
      end

      it "removes version file" do
        engine.run

        expect(cli).to have_received(:remove_file).with(
          "tester/lib/tester/version.rb",
          configuration
        )
      end

      it "removes license file" do
        engine.run
        expect(cli).to have_received(:remove_file).with("tester/MIT-LICENSE", configuration)
      end

      it "removes readme file" do
        engine.run
        expect(cli).to have_received(:remove_file).with("tester/README.rdoc", configuration)
      end
    end

    context "when engine is disabled" do
      let(:configuration) { {gem: {name: "tester", path: "tester"}, generate: {engine: false}} }

      it "does not creates engine file" do
        engine.run

        expect(cli).not_to have_received(:template).with(
          "%gem_name%/lib/%gem_path%/engine.rb.tt",
          configuration
        )
      end

      it "does not generate engine" do
        engine.run

        expect(cli).not_to have_received(:run).with(
          %(rails plugin new --skip tester #{options.join " "})
        )
      end

      it "does not create install generator script" do
        engine.run

        expect(cli).not_to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/install/install_generator.rb.tt",
          configuration
        )
      end

      it "does not create install generator usage documentation" do
        engine.run

        expect(cli).not_to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/install/USAGE.tt",
          configuration
        )
      end

      it "does not create upgrade generator script" do
        engine.run

        expect(cli).not_to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/upgrade/upgrade_generator.rb.tt",
          configuration
        )
      end

      it "does not create upgrade generator usage documentation" do
        engine.run

        expect(cli).not_to have_received(:template).with(
          "%gem_name%/lib/generators/%gem_path%/upgrade/USAGE.tt",
          configuration
        )
      end

      it "does not stub JavaScript application file" do
        engine.run

        expect(cli).not_to have_received(:run).with(
          %(printf "%s" > "tester/app/assets/javascripts/tester/application.js")
        )
      end

      it "does not stub stylesheet application file" do
        engine.run

        expect(cli).not_to have_received(:run).with(
          %(printf "%s" > "tester/app/assets/stylesheets/tester/application.css")
        )
      end

      it "does not remove application helper file" do
        engine.run

        expect(cli).not_to have_received(:remove_file).with(
          "tester/app/helpers/tester/application_helper.rb",
          configuration
        )
      end

      it "does not removes version file" do
        engine.run

        expect(cli).not_to have_received(:remove_file).with(
          "tester/lib/tester/version.rb",
          configuration
        )
      end

      it "does not remove license file" do
        engine.run
        expect(cli).not_to have_received(:remove_file).with("tester/MIT-LICENSE", configuration)
      end

      it "does not remove readme file" do
        engine.run
        expect(cli).not_to have_received(:remove_file).with("tester/README.rdoc", configuration)
      end
    end
  end
end
