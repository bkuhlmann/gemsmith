# frozen_string_literal: true

require "dry/container/stub"
require "infusible/stub"

RSpec.shared_context "with application dependencies" do
  using Refinements::Structs
  using Infusible::Stub

  include_context "with temporary directory"

  let :configuration do
    Gemsmith::Configuration::Loader.with_overrides.call.merge(
      author_family_name: "Smith",
      author_given_name: "Jill",
      now: Time.local(2020, 1, 1, 0, 0, 0),
      project_name: "test",
      target_root: temp_dir
    )
  end

  let(:kernel) { class_spy Kernel }
  let(:executor) { class_spy Open3, capture3: ["Output.", "Error.", Process::Status.allocate] }
  let(:logger) { Cogger.new io: StringIO.new, level: :debug, formatter: :emoji }

  let :specification do
    Spek::Loader.call SPEC_ROOT.join("support/fixtures/gemsmith-test.gemspec")
  end

  before { Gemsmith::Import.stub configuration:, kernel:, executor:, logger: }

  after { Gemsmith::Import.unstub :configuration, :kernel, :executor, :logger }
end
