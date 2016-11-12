# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Base do
  let(:cli) { instance_spy Gemsmith::CLI }
  subject { described_class.new cli }

  describe ".create" do
    it "initializes instance and creates it" do
      result = -> { described_class.create cli }
      expect(&result).to raise_error(NotImplementedError, "The method, #create, is not implemented yet.")
    end
  end

  describe "#create" do
    it "fails due to not being implemented yet" do
      result = -> { subject.create }
      expect(&result).to raise_error(NotImplementedError, "The method, #create, is not implemented yet.")
    end
  end
end
