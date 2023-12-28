# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::RSpec::Helper do
  using Refinements::Struct
  using Refinements::Pathname

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:spec_helper_path) { temp_dir.join "test/spec/spec_helper.rb" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled with CLI only" do
      let :test_configuration do
        configuration.minimize.merge build_rspec: true, build_cli: true, build_simple_cov: true
      end

      it "updates spec helper" do
        Rubysmith::Builders::RSpec::Helper.call test_configuration
        builder.call

        expect(spec_helper_path.read).to include("add_filter %r((.+/container\\.rb|^/spec/))")
      end
    end

    context "when enabled without CLI" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "doesn't touch spec helper" do
        builder.call
        expect(spec_helper_path.exist?).to be(false)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't touch spec helper" do
        builder.call
        expect(spec_helper_path.exist?).to be(false)
      end
    end
  end
end
