# frozen_string_literal: true

RSpec.shared_examples "a builder" do
  describe ".call" do
    it "answers maximum configuration" do
      maximum = configuration.maximize
      expect(described_class.call(maximum)).to eq(maximum)
    end

    it "answers minimum configuration" do
      minimum = configuration.minimize
      expect(described_class.call(minimum)).to eq(minimum)
    end
  end
end
