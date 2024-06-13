# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  using Refinements::Struct

  include_context "with temporary directory"

  let(:settings) { Gemsmith::Container[:settings] }
  let(:specification) { Spek::Loader.call SPEC_ROOT.join("support/fixtures/gemsmith-test.gemspec") }
  let(:executor) { class_spy Open3, capture3: ["Output.", "Error.", Process::Status.allocate] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :gemsmith, io: StringIO.new, level: :debug }

  before do
    settings.merge! Etcher.call(
      Gemsmith::Container[:registry].remove_loader(1),
      author_family_name: "Smith",
      author_given_name: "Jill",
      author_email: "jill@acme.io",
      loaded_at: Time.utc(2020, 1, 1, 0, 0, 0),
      target_root: temp_dir,
      project_name: "test"
    )

    Gemsmith::Container.stub! executor:, kernel:, logger:
  end

  after { Gemsmith::Container.restore }
end
