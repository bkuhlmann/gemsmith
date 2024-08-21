# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::Console do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/bin/console" }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_console: true }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require "test"
          require "irb"

          IRB.start __FILE__
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with dashed project name" do
      before do
        settings.merge! settings.minimize.merge project_name: "demo-test", build_console: true
      end

      let(:path) { temp_dir.join "demo-test/bin/console" }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require "demo/test"
          require "irb"

          IRB.start __FILE__
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
