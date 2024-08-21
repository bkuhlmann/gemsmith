# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Commands::Build do
  using Refinements::Pathname

  subject(:command) { described_class.new builders: [Rubysmith::Builders::Version] }

  include_context "with application dependencies"

  describe "#call" do
    it "builds skeleton" do
      temp_dir.change_dir { command.call }
      expect(temp_dir.join("test/.ruby-version").exist?).to be(true)
    end

    it "logs information" do
      temp_dir.change_dir { command.call }
      expect(logger.reread).to match(%r(🟢.+Rendering: test/.ruby-version))
    end
  end
end
