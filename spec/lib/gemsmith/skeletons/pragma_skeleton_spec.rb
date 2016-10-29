# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::PragmaSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester" }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  let(:comments) { ["# frozen_string_literal: true"] }
  let(:pragmater) { instance_spy Pragmater::Writer }
  let(:source_file) { Pathname.new File.join(gem_dir, "test.rb") }
  subject { described_class.new cli, configuration: configuration }
  before do
    allow(Pragmater::Writer).to receive(:new).with(source_file, comments).and_return(pragmater)
    FileUtils.mkdir gem_dir
    FileUtils.touch source_file
  end

  describe "#whitelist" do
    it "answers whitelist" do
      expect(subject.whitelist).to contain_exactly(
        "Gemfile",
        "Guardfile",
        "Rakefile",
        "config.ru",
        "bin/#{configuration.gem_name}",
        "bin/rails",
        ".gemspec",
        ".rake",
        ".rb"
      )
    end
  end

  describe "#create" do
    before { subject.create }

    it "updates files" do
      expect(pragmater).to have_received(:add)
    end
  end
end
