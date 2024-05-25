# frozen_string_literal: true

# rubocop:todo RSpec/MultipleMemoizedHelpers
RSpec.shared_context "with application dependencies" do
  include_context "with temporary directory"

  let :configuration do
    Etcher.new(Gemsmith::Container[:defaults])
          .call(
            author_family_name: "Smith",
            author_given_name: "Jill",
            author_email: "jill@example.com",
            author_url: "https://example.com/team/jill",
            git_hub_user: "hubber",
            loaded_at: Time.utc(2020, 1, 1, 0, 0, 0),
            organization_url: "https://example.com",
            project_name: "test",
            project_url_community: "https://example.com/%project_name%/community",
            project_url_conduct: "https://example.com/%project_name%/code_of_conduct",
            project_url_contributions: "https://example.com/%project_name%/contributions",
            project_url_download: "https://example.com/%project_name%/download",
            project_url_home: "https://example.com/%project_name%",
            project_url_issues: "https://example.com/%project_name%/issues",
            project_url_license: "https://example.com/%project_name%/license",
            project_url_security: "https://example.com/%project_name%/security",
            project_url_source: "https://example.com/%project_name%/source",
            project_url_versions: "https://example.com/%project_name%/versions",
            target_root: temp_dir
          )
          .bind(&:dup)
  end

  let(:input) { configuration.dup }
  let(:xdg_config) { Runcom::Config.new Gemsmith::Container[:defaults_path] }
  let(:specification) { Spek::Loader.call SPEC_ROOT.join("support/fixtures/gemsmith-test.gemspec") }
  let(:executor) { class_spy Open3, capture3: ["Output.", "Error.", Process::Status.allocate] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :gemsmith, io: StringIO.new, level: :debug }

  before do
    Gemsmith::Container.stub! configuration:, input:, xdg_config:, executor:, kernel:, logger:
  end

  after { Gemsmith::Container.restore }
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
