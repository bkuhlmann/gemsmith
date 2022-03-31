# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Pusher do
  subject(:pusher) { described_class.new command: }

  include_context "with application container"

  let(:command) { instance_spy Gem::CommandManager, run: nil }

  describe "#call" do
    let(:executor) { class_double Open3, capture3: ["abc", "Unknown", status] }
    let(:status) { instance_double Process::Status }

    context "when YubiKey Manager exists and One-Time Password is obtained" do
      before { allow(status).to receive(:success?).and_return(true, true) }

      it "pushes with One-Time Password" do
        pusher.call specification

        expect(command).to have_received(:run).with(
          ["push", "tmp/gemsmith-test-0.0.0.gem", "--otp", "abc"]
        )
      end

      it "answers specification" do
        result = pusher.call specification
        expect(result.success).to eq(specification)
      end

      it "answers error message with gem exception failure" do
        allow(command).to receive(:run).and_raise Gem::Exception, "Exception!"
        result = pusher.call specification

        expect(result.failure).to eq("Exception!")
      end
    end

    context "when YubiKey Manager exists and One-Time Password can't be obtained" do
      before { allow(status).to receive(:success?).and_return(true, false) }

      it "pushes without One-Time Password" do
        pusher.call specification
        expect(command).to have_received(:run).with(["push", "tmp/gemsmith-test-0.0.0.gem"])
      end

      it "answers specification" do
        result = pusher.call specification
        expect(result.success).to eq(specification)
      end
    end

    context "when YubiKey Manager doesn't exist" do
      before { allow(status).to receive(:success?).and_return(false, true) }

      it "pushes without One-Time Password" do
        pusher.call specification
        expect(command).to have_received(:run).with(["push", "tmp/gemsmith-test-0.0.0.gem"])
      end

      it "logs warning" do
        pusher.call specification
        expect(logger.reread).to eq("Unable to find YubiKey Manager. Unknown.\n")
      end

      it "answers specification" do
        result = pusher.call specification
        expect(result.success).to eq(specification)
      end
    end

    context "when system error is raised" do
      before { allow(executor).to receive(:capture3).and_raise(Errno::ENOENT, "Danger") }

      it "pushes without One-Time Password" do
        pusher.call specification
        expect(command).to have_received(:run).with(["push", "tmp/gemsmith-test-0.0.0.gem"])
      end

      it "logs warning" do
        pusher.call specification

        expect(logger.reread).to eq(
          "Unable to obtain YubiKey One-Time Password. No such file or directory - Danger.\n"
        )
      end

      it "answers specification" do
        result = pusher.call specification
        expect(result.success).to eq(specification)
      end
    end
  end
end
