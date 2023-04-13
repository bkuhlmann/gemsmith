require "spec_helper"

RSpec.describe Test::CLI::Shell do
  using Refinements::Pathnames
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Test::CLI::Actions::Import.stub configuration:, kernel:, logger: }

  after { Test::CLI::Actions::Import.unstub :configuration, :kernel, :logger }

  describe "#call" do
    it "edits configuration" do
      shell.call %w[--config edit]
      expect(kernel).to have_received(:system).with("$EDITOR ")
    end

    it "views configuration" do
      shell.call %w[--config view]
      expect(kernel).to have_received(:system).with("cat ")
    end

    it "prints version" do
      shell.call %w[--version]
      expect(kernel).to have_received(:puts).with(/Test\s\d+\.\d+\.\d+/)
    end

    it "prints help (usage)" do
      shell.call %w[--help]
      expect(kernel).to have_received(:puts).with(/Test.+USAGE.+/m)
    end

    it "prints usage when no options are given" do
      shell.call
      expect(kernel).to have_received(:puts).with(/Test.+USAGE.+/m)
    end

    it "prints error with invalid option" do
      shell.call %w[--bogus]
      expect(logger.reread).to match(/🛑.+invalid option.+bogus/)
    end
  end
end
