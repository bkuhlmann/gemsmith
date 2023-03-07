# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Builders::RSpec::Helper do
  using Refinements::Structs
  using Refinements::Pathnames

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:spec_helper_path) { temp_dir.join "test/spec/spec_helper.rb" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled with CLI only" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true, build_cli: true }

      before do
        temp_dir.join("test/spec")
                .make_path.join("spec_helper.rb")
                .write %(Pathname.require_tree SPEC_ROOT.join("support/shared_contexts")\n)
      end

      it "updates spec helper" do
        builder.call

        expect(spec_helper_path.read).to eq(<<~CONTENT)
          Pathname.require_tree SPEC_ROOT.join("support/shared_contexts")
          Pathname.require_tree SPEC_ROOT.join("support/shared_examples")
        CONTENT
      end

      it "renders shared example" do
        builder.call
        template = temp_dir.join("test/spec/support/shared_examples/a_parser.rb").read

        expect(template).to eq(<<~CONTENT)
          RSpec.shared_examples "a parser" do
            describe ".call" do
              it "answers configuration" do
                expect(described_class.call).to be_a(Test::Configuration::Content)
              end
            end
          end
        CONTENT
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
