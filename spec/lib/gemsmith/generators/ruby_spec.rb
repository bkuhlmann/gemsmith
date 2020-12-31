# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Generators::Ruby do
  subject(:ruby) { described_class.new cli, configuration: configuration }

  include_context "with temporary directory"

  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { {gem: {name: "tester"}} }

  describe "#run" do
    it "creates files" do
      ruby.run
      expect(cli).to have_received(:template).with("%gem_name%/.ruby-version.tt", configuration)
    end
  end
end
