require "spec_helper"

describe Gemsmith::Skeletons::BaseSkeleton do
  let(:cli) { instance_spy Gemsmith::CLI }
  subject { described_class.new cli }

  describe ".create" do
    it "initializes instance and creates it" do
      result = -> { described_class.create cli }
      expect(&result).to raise_error(NotImplementedError, "The method, #create, is not implemented yet.")
    end
  end

  describe "#enabled?" do
    it "is enabled by default" do
      expect(subject.enabled?).to eq(true)
    end
  end

  describe "#create" do
    it "fails due to not being implemented yet" do
      result = -> { subject.create }
      expect(&result).to raise_error(NotImplementedError, "The method, #create, is not implemented yet.")
    end
  end
end
