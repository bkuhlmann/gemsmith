# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Pusher do
  subject(:pusher) { described_class.new command: }

  include_context "with application container"

  let(:command) { instance_spy Gem::CommandManager, run: nil }

  describe "#call" do
    let(:executor) { class_double Open3, capture3: ["abc", "Unknown!", status] }
    let(:status) { instance_double Process::Status, success?: true }

    it "answers specification when success" do
      result = pusher.call specification
      expect(result.success).to eq(specification)
    end

    it "uses One-Time Password when obtained" do
      pusher.call specification

      expect(command).to have_received(:run).with(
        ["push", "tmp/gemsmith-test-0.0.0.gem", "--otp", "abc"]
      )
    end

    it "doesn't use One-Time Password when it can't be obtained" do
      allow(status).to receive(:success?).and_return(false)
      pusher.call specification

      expect(command).to have_received(:run).with(["push", "tmp/gemsmith-test-0.0.0.gem"])
    end

    it "answers error message when failure" do
      allow(command).to receive(:run).and_raise Gem::Exception, "Exception!"
      result = pusher.call specification

      expect(result.failure).to eq("Exception!")
    end
  end
end
