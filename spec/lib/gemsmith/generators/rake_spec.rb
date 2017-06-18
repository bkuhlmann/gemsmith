# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rake, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:generate_rspec) { false }
  let(:generate_git_cop) { false }
  let(:generate_reek) { false }
  let(:generate_rubocop) { false }
  let(:generate_scss_lint) { false }

  let :configuration do
    {
      gem: {
        name: "tester"
      },
      generate: {
        rspec: generate_rspec,
        git_cop: generate_git_cop,
        reek: generate_reek,
        rubocop: generate_rubocop,
        scss_lint: generate_scss_lint
      }
    }
  end

  let(:rakefile) { File.join temp_dir, "Rakefile" }
  subject { described_class.new cli, configuration: configuration }

  describe "generate_code_quality_task" do
    let(:task) { subject.generate_code_quality_task }

    context "when only Git Cop is enabled" do
      let(:generate_git_cop) { true }

      it "adds Git Cop task" do
        expect(task).to eq(%(\ndesc "Run code quality checks"\ntask code_quality: %i[git_cop]\n))
      end
    end

    context "when only Reek is enabled" do
      let(:generate_reek) { true }

      it "adds Reek task" do
        expect(task).to eq(%(\ndesc "Run code quality checks"\ntask code_quality: %i[reek]\n))
      end
    end

    context "when only Rubocop is enabled" do
      let(:generate_rubocop) { true }

      it "adds Rubocop task" do
        expect(task).to eq(%(\ndesc "Run code quality checks"\ntask code_quality: %i[rubocop]\n))
      end
    end

    context "when only SCSS Lint is enabled" do
      let(:generate_scss_lint) { true }

      it "adds SCSS Lint task" do
        expect(task).to eq(
          %(\ndesc "Run code quality checks"\ntask code_quality: %i[scss_lint]\n)
        )
      end
    end

    context "when all tasks are enabled" do
      let(:generate_git_cop) { true }
      let(:generate_reek) { true }
      let(:generate_rubocop) { true }
      let(:generate_scss_lint) { true }

      it "adds all code quality tasks" do
        tasks = "%i[git_cop reek rubocop scss_lint]"
        expect(task).to eq(%(\ndesc "Run code quality checks"\ntask code_quality: #{tasks}\n))
      end
    end

    context "when no tasks are enabled" do
      it "does not add code quality task" do
        expect(task).to eq("")
      end
    end
  end

  describe "generate_default_task" do
    let(:task) { subject.generate_default_task }

    context "when any code quality task is enabled" do
      let(:generate_reek) { true }

      it "adds code quality task" do
        expect(task).to eq(%(\ntask default: %i[code_quality]\n))
      end
    end

    context "when only RSpec is enabled" do
      let(:generate_rspec) { true }

      it "adds RSpec task" do
        expect(task).to eq(%(\ntask default: %i[spec]\n))
      end
    end

    context "when all tasks are enabled" do
      let(:generate_reek) { true }
      let(:generate_rspec) { true }

      it "adds code quality and RSpec tasks" do
        expect(task).to eq(%(\ntask default: %i[code_quality spec]\n))
      end
    end

    context "when no tasks are enabled" do
      it "answers an empty string" do
        expect(task).to eq("")
      end
    end
  end

  describe "#run" do
    before { subject.run }

    it "creates Rakefile" do
      expect(cli).to have_received(:template).with("%gem_name%/Rakefile.tt", configuration)
    end

    context "when all tasks are enabled" do
      let(:generate_rspec) { true }
      let(:generate_git_cop) { true }
      let(:generate_reek) { true }
      let(:generate_rubocop) { true }
      let(:generate_scss_lint) { true }

      it "adds code quality and default tasks", :aggregate_failures do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          subject.generate_code_quality_task
        )

        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          subject.generate_default_task
        )
      end
    end

    context "when no tasks are enabled" do
      it "adds code quality and default tasks" do
        expect(cli).to_not have_received(:append_to_file)
      end
    end
  end
end
