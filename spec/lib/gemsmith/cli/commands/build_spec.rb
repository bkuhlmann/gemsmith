# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI::Commands::Build do
  subject(:command) { described_class.new builders: [builder] }

  include_context "with application dependencies"

  let(:builder) { class_spy Gemsmith::Builders::Specification }

  describe "#call" do
    it "logs message" do
      command.call
      expect(logger.reread).to eq(<<~OUTPUT)
        🟢 \e[32mBuilding project skeleton: test...\e[0m
        🟢 \e[32mProject skeleton complete!\e[0m
      OUTPUT
    end

    it "calls builders" do
      command.call
      expect(builder).to have_received(:call).with(configuration)
    end
  end
end
