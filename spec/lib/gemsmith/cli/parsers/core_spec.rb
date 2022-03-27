# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Parsers::Core do
  subject(:parser) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a parser"

  describe "#call" do
    let(:test_configuration) { configuration.minimize.dup }

    it "answers config edit (short)" do
      expect(parser.call(%w[-c edit])).to have_attributes(action_config: :edit)
    end

    it "answers config edit (long)" do
      expect(parser.call(%w[--config edit])).to have_attributes(action_config: :edit)
    end

    it "answers config view (short)" do
      expect(parser.call(%w[-c view])).to have_attributes(action_config: :view)
    end

    it "answers config view (long)" do
      expect(parser.call(%w[--config view])).to have_attributes(action_config: :view)
    end

    it "fails with missing config action" do
      expectation = proc { parser.call %w[--config] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--config/)
    end

    it "fails with invalid config action" do
      expectation = proc { parser.call %w[--config bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidArgument, /bogus/)
    end

    it "answers build (short)" do
      expect(parser.call(%w[-b test])).to have_attributes(action_build: true, project_name: "test")
    end

    it "answers build (long)" do
      expect(parser.call(%w[--build test])).to have_attributes(
        action_build: true,
        project_name: "test"
      )
    end

    it "fails with missing build name" do
      expectation = proc { parser.call %w[--build] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--build/)
    end

    it "answers edit" do
      expect(parser.call(%w[--edit test])).to have_attributes(action_edit: "test")
    end

    it "fails with missing editable gem name" do
      expectation = proc { parser.call %w[--edit] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--edit/)
    end

    it "answers install (short) with default project name" do
      expect(parser.call(%w[-i])).to have_attributes(
        action_install: true,
        project_name: kind_of(String)
      )
    end

    it "answers install (long) with default project name" do
      expect(parser.call(%w[--install])).to have_attributes(
        action_install: true,
        project_name: kind_of(String)
      )
    end

    it "answers install (short) with custom project name)" do
      expect(parser.call(%w[-i test])).to have_attributes(
        action_install: true,
        project_name: "test"
      )
    end

    it "answers install (long) with custom project name" do
      expect(parser.call(%w[--install test])).to have_attributes(
        action_install: true,
        project_name: "test"
      )
    end

    it "answers publish (short) with default project name" do
      expect(parser.call(%w[-p])).to have_attributes(
        action_publish: true,
        project_name: kind_of(String)
      )
    end

    it "answers publish (long) with default project name" do
      expect(parser.call(%w[--publish])).to have_attributes(
        action_publish: true,
        project_name: kind_of(String)
      )
    end

    it "answers publish (short) with custom project name)" do
      expect(parser.call(%w[-p test])).to have_attributes(
        action_publish: true,
        project_name: "test"
      )
    end

    it "answers publish (long) with custom project name" do
      expect(parser.call(%w[--publish test])).to have_attributes(
        action_publish: true,
        project_name: "test"
      )
    end

    it "answers view" do
      expect(parser.call(%w[--view test])).to have_attributes(action_view: "test")
    end

    it "fails with missing viewable gem name" do
      expectation = proc { parser.call %w[--view] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--view/)
    end

    it "answers version (short)" do
      expect(parser.call(%w[-v])).to have_attributes(action_version: true)
    end

    it "answers version (long)" do
      expect(parser.call(%w[--version])).to have_attributes(action_version: true)
    end

    it "enables help (short)" do
      expect(parser.call(%w[-h])).to have_attributes(action_help: true)
    end

    it "enables help (long)" do
      expect(parser.call(%w[--help])).to have_attributes(action_help: true)
    end
  end
end
