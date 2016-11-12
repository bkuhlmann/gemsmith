# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Base do
  let(:cli) { instance_spy Gemsmith::CLI }
  subject { described_class.new cli }

  describe ".run" do
    it "initializes instance and runs it" do
      result = -> { described_class.run cli }
      expect(&result).to raise_error(NotImplementedError, "The method, #run, is not implemented yet.")
    end
  end

  describe "#run" do
    it "fails due to not being implemented yet" do
      result = -> { subject.run }
      expect(&result).to raise_error(NotImplementedError, "The method, #run, is not implemented yet.")
    end
  end
end
