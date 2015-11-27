require "spec_helper"

describe Gemsmith::Aids::Spec do
  let(:specification) { class_spy ::Gem::Specification }
  let(:shell) { class_spy Open3 }
  subject { described_class.new specification: specification, shell: shell }

  describe "#editor" do
    it "answers current editor/IDE for editing source code" do
      ClimateControl.modify EDITOR: "sublime" do
        expect(subject.editor).to eq("sublime")
      end
    end
  end

  describe "#open" do
    let(:spec) { instance_spy ::Gem::Specification, full_gem_path: "/full/gem/path" }

    it "opens gem for editing" do
      subject.open spec
      expect(shell).to have_received(:capture2).with(subject.editor, "/full/gem/path")
    end

    it "answers full path to installed gem source code" do
      expect(subject.open(spec)).to eq("/full/gem/path")
    end

    it "does nothing when spec is missing" do
      subject.open
      expect(shell).to_not have_received(:capture2)
    end
  end

  describe "#read" do
    let(:spec) { instance_spy ::Gem::Specification, homepage: "https://www.example.com" }

    it "opens gem for editing" do
      subject.read spec
      expect(shell).to have_received(:capture2).with("open", "https://www.example.com")
    end

    it "answers gem home page URL" do
      expect(subject.read(spec)).to eq("https://www.example.com")
    end

    it "does nothing when spec is missing" do
      subject.read
      expect(shell).to_not have_received(:capture2)
    end

    context "when homepage is nil" do
      let(:spec) { instance_spy ::Gem::Specification, homepage: nil }

      it "does nothing" do
        subject.read spec
        expect(shell).to_not have_received(:capture2)
      end
    end

    context "when homepage is empty" do
      let(:spec) { instance_spy ::Gem::Specification, homepage: "" }

      it "does nothing" do
        subject.read
        expect(shell).to_not have_received(:capture2)
      end
    end
  end

  describe "#find" do
    it "answers matching gem spec" do
      subject.find "test", "1.0.0"
      expect(specification).to have_received(:find_by_name).with("test", "1.0.0")
    end
  end

  describe "#find_all" do
    it "answers matching gem specs" do
      subject.find_all "test"
      expect(specification).to have_received(:find_all_by_name).with("test")
    end
  end
end
