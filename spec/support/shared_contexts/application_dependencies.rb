# frozen_string_literal: true

require "dry/container/stub"
require "infusible/stub"

# rubocop:todo RSpec/MultipleMemoizedHelpers
RSpec.shared_context "with application dependencies" do
  using Infusible::Stub

  include_context "with temporary directory"

  let :configuration do
    Etcher.new(Gemsmith::Container[:defaults])
          .call(
            author_family_name: "Smith",
            author_given_name: "Jill",
            author_email: "jill@example.com",
            git_hub_user: "hubber",
            now: Time.local(2020, 1, 1, 0, 0, 0),
            project_name: "test",
            target_root: temp_dir
          )
          .bind(&:dup)
  end

  let(:input) { configuration.dup }
  let(:xdg_config) { Runcom::Config.new Gemsmith::Container[:defaults_path] }
  let(:specification) { Spek::Loader.call SPEC_ROOT.join("support/fixtures/gemsmith-test.gemspec") }
  let(:executor) { class_spy Open3, capture3: ["Output.", "Error.", Process::Status.allocate] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new io: StringIO.new, level: :debug, formatter: :emoji }

  before { Gemsmith::Import.stub configuration:, input:, xdg_config:, executor:, kernel:, logger: }

  after { Gemsmith::Import.unstub :configuration, :input, :xdg_config, :executor, :kernel, :logger }
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
