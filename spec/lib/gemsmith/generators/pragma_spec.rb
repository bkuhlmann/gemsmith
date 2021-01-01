# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Pragma do
  subject(:pragma) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  using Refinements::Pathnames

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  let(:comments) { ["# frozen_string_literal: true"] }
  let(:pragmater) { instance_spy Pragmater::Runner }
  let(:gem_root) { temp_dir.join "tester" }
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

  before do
    allow(Pragmater::Runner).to receive(:for).with(
      action: :insert,
      root_dir: gem_root,
      comments: comments,
      includes: includes
    ).and_return(pragmater)

    gem_root.make_path
    source_file.touch
  end

  describe "#includes" do
    it "answers includes" do
      expect(pragma.includes).to contain_exactly(*includes)
    end
  end

  describe "#run" do
    before { pragma.run }

    it "updates files" do
      expect(pragmater).to have_received(:call)
    end
  end
end
