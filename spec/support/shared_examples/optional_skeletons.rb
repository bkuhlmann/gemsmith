shared_examples_for "an optional skeleton" do |key|
  describe "#enabled?" do
    it "is enabled" do
      options.merge! key => true
      expect(subject.enabled?).to eq(true)
    end

    it "is disabled when option is false" do
      options.merge! key => false
      expect(subject.enabled?).to eq(false)
    end

    it "is disabled when option is missing" do
      expect(subject.enabled?).to eq(false)
    end
  end
end
