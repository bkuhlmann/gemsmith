# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Git::Commit do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration, specification: }

  include_context "with application dependencies"

  let(:project_dir) { temp_dir.join "test" }
  let(:commit) { project_dir.change_dir { `git log --pretty=format:%s%n%n%b -1` } }

  let :specification do
    instance_double Spek::Presenter,
                    label: "Test",
                    homepage_url: "https://example.com",
                    version: "0.0.0"
  end

  it_behaves_like "a builder"

  describe "#call" do
    before do
      project_dir.make_path.change_dir do |path|
        `git init`
        `git config user.name "#{configuration.author_name}"`
        `git config user.email "#{configuration.author_email}"`
        path.join("test.txt").touch
      end

      temp_dir.change_dir { builder.call }
    end

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_git: true }

      it "creates commit" do
        expect(commit).to eq(<<~MESSAGE)
          Added project skeleton

          Generated with [Test](https://example.com) 0.0.0.
        MESSAGE
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't create commit" do
        expect(commit).to eq("")
      end
    end
  end
end
