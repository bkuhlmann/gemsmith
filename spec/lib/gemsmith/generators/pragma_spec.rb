# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Pragma, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  let(:comments) { ["# frozen_string_literal: true"] }
  let(:pragmater) { instance_spy Pragmater::Runner }
  let(:gem_root) { File.join temp_dir, "tester" }
  let(:source_file) { Pathname "#{gem_root}/test.rb" }

  let :includes do
    %w[
      **/*Gemfile
      **/*Guardfile
      **/*Rakefile
      **/*config.ru
      **/*bin/tester
      **/*bin/bundle
      **/*bin/rails
      **/*bin/rake
      **/*bin/setup
      **/*bin/update
      **/*bin/yarn
      **/*.gemspec
      **/*.rake
      **/*.rb
    ]
  end

  subject { described_class.new cli, configuration: configuration }

  before do
    allow(Pragmater::Runner).to receive(:new).with(
      gem_root,
      comments: comments,
      includes: includes
    ).and_return(pragmater)
    FileUtils.mkdir_p gem_root
    FileUtils.touch source_file
  end

  describe "#includes" do
    it "answers includes" do
      expect(subject.includes).to contain_exactly(*includes)
    end
  end

  describe "#run" do
    before { subject.run }

    it "updates files" do
      expect(pragmater).to have_received(:run).with(action: :add)
    end
  end
end
