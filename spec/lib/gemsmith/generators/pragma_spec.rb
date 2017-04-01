# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Pragma, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  let(:comments) { ["# frozen_string_literal: true"] }
  let(:pragmater) { instance_spy Pragmater::Writer }
  let(:gem_root) { File.join temp_dir, "tester" }
  let(:source_file) { Pathname.new File.join(gem_root, "test.rb") }
  subject { described_class.new cli, configuration: configuration }
  before do
    allow(Pragmater::Writer).to receive(:new).with(source_file, comments).and_return(pragmater)
    FileUtils.mkdir_p gem_root
    FileUtils.touch source_file
  end

  describe "#whitelist" do
    it "answers whitelist" do
      expect(subject.whitelist).to contain_exactly(
        "Gemfile",
        "Guardfile",
        "Rakefile",
        "config.ru",
        "bin/#{configuration.dig :gem, :name}",
        "bin/rails",
        ".gemspec",
        ".rake",
        ".rb"
      )
    end
  end

  describe "#run" do
    before { subject.run }

    it "updates files" do
      expect(pragmater).to have_received(:add)
    end
  end
end
