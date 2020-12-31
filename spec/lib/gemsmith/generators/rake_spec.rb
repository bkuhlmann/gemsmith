# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Rake do
  subject(:rake) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:generate_rspec) { false }
  let(:generate_bundler_audit) { false }
  let(:generate_git_lint) { false }
  let(:generate_reek) { false }
  let(:generate_rubocop) { false }

  let :configuration do
    {
      gem: {
        name: "tester"
      },
      generate: {
        rspec: generate_rspec,
        bundler_audit: generate_bundler_audit,
        git_lint: generate_git_lint,
        reek: generate_reek,
        rubocop: generate_rubocop
      }
    }
  end

  let(:rakefile) { File.join temp_dir, "Rakefile" }

  describe "generate_code_quality_task" do
    let(:task) { rake.generate_code_quality_task }

    context "when only Bundler Audit is enabled" do
      let(:generate_bundler_audit) { true }

      it "adds Bundler Audit task" do
        expect(task).to eq(
          %(\ndesc "Run code quality checks"\ntask code_quality: %i[bundle:audit]\n)
        )
      end
    end

    context "when only Git Lint is enabled" do
      let(:generate_git_lint) { true }

      it "adds Git Lint task" do
        expect(task).to eq(%(\ndesc "Run code quality checks"\ntask code_quality: %i[git_lint]\n))
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

    context "when all tasks are enabled" do
      let(:generate_bundler_audit) { true }
      let(:generate_git_lint) { true }
      let(:generate_reek) { true }
      let(:generate_rubocop) { true }

      it "adds all code quality tasks" do
        tasks = "%i[bundle:audit git_lint reek rubocop]"
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
    let(:task) { rake.generate_default_task }

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
    before { rake.run }

    it "creates Rakefile" do
      expect(cli).to have_received(:template).with("%gem_name%/Rakefile.tt", configuration)
    end

    context "when all tasks are enabled" do
      let(:generate_rspec) { true }
      let(:generate_bundler_audit) { true }
      let(:generate_git_lint) { true }
      let(:generate_reek) { true }
      let(:generate_rubocop) { true }

      it "adds code quality and default tasks", :aggregate_failures do
        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          rake.generate_code_quality_task
        )

        expect(cli).to have_received(:append_to_file).with(
          "%gem_name%/Rakefile",
          rake.generate_default_task
        )
      end
    end

    context "when no tasks are enabled" do
      it "adds code quality and default tasks" do
        expect(cli).not_to have_received(:append_to_file)
      end
    end
  end
end
