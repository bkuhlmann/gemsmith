# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Ruby, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }
  subject { described_class.new cli, configuration: configuration }

  describe "#create" do
    it "creates files" do
      subject.create
      expect(cli).to have_received(:template).with("%gem_name%/.ruby-version.tt", configuration)
    end
  end
end
