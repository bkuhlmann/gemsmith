require "spec_helper"

describe Gemsmith::CLI do
  let(:cli) { described_class.new }

  describe ".skeletons" do
    it "answers gem skeletons" do
      expect(described_class.skeletons).to contain_exactly(Gemsmith::Skeletons::GemSkeleton,
                                                           Gemsmith::Skeletons::DocumentationSkeleton,
                                                           Gemsmith::Skeletons::RakeSkeleton,
                                                           Gemsmith::Skeletons::CLISkeleton,
                                                           Gemsmith::Skeletons::RubySkeleton,
                                                           Gemsmith::Skeletons::RailsSkeleton,
                                                           Gemsmith::Skeletons::RspecSkeleton,
                                                           Gemsmith::Skeletons::RubocopSkeleton,
                                                           Gemsmith::Skeletons::GuardSkeleton,
                                                           Gemsmith::Skeletons::PrySkeleton,
                                                           Gemsmith::Skeletons::TravisSkeleton,
                                                           Gemsmith::Skeletons::BundlerSkeleton,
                                                           Gemsmith::Skeletons::GitSkeleton)
    end
  end
end
