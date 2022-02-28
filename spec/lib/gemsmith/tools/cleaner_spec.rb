# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Tools::Cleaner do
  using Refinements::Pathnames

  subject(:cleaner) { described_class.new }

  include_context "with application container"

  describe "#call" do
    it "deletes Gemsmith artifacts" do
      temp_dir.change_dir do
        path = temp_dir.join("tmp/gemsmith-test-0.0.0.gem").deep_touch
        cleaner.call specification

        expect(path.exist?).to be(false)
      end
    end

    it "deletes Bundler artifacts" do
      temp_dir.change_dir do
        temp_dir.join("pkg/gemsmith-test-0.0.0.gem").deep_touch
        cleaner.call specification

        expect(temp_dir.join("pkg").exist?).to be(false)
      end
    end

    it "deletes extraneous root artifacts" do
      temp_dir.change_dir do
        path = temp_dir.join("gemsmith-test-0.0.0.gem").touch
        cleaner.call specification

        expect(path.exist?).to be(false)
      end
    end
  end
end
