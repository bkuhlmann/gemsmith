# frozen_string_literal: true

require "dry/container/stub"

RSpec.shared_context "with application container" do
  using Refinements::Structs

  include_context "with temporary directory"

  let(:container) { Gemsmith::Container }

  let :configuration do
    Gemsmith::Configuration::Loader.with_overrides.call.merge(
      author_email: "jill@example.com",
      author_family_name: "Smith",
      author_given_name: "Jill",
      author_url: "https://www.jillsmith.com",
      citation_affiliation: "ACME",
      citation_orcid: "0000-1111-2222-3333",
      git_hub_user: "hubber",
      now: Time.local(2020, 1, 1, 0, 0, 0),
      project_name: "test",
      project_url_community: "https://www.example.com/%project_name%/community",
      project_url_conduct: "https://www.example.com/%project_name%/code_of_conduct",
      project_url_contributions: "https://www.example.com/%project_name%/contributions",
      project_url_download: "https://www.example.com/%project_name%/download",
      project_url_home: "https://www.example.com/%project_name%",
      project_url_issues: "https://www.example.com/%project_name%/issues",
      project_url_license: "https://www.example.com/%project_name%/license",
      project_url_security: "https://www.example.com/%project_name%/security",
      project_url_source: "https://www.example.com/%project_name%/source",
      project_url_versions: "https://www.example.com/%project_name%/versions",
      target_root: temp_dir,
      template_roots: [
        Bundler.root.join("lib/gemsmith/templates"),
        *Rubysmith::Container[:configuration].template_roots
      ]
    )
  end

  let(:kernel) { class_spy Kernel }
  let(:executor) { class_spy Open3, capture3: ["Output.", "Error.", Process::Status.allocate] }

  let :specification do
    Gemsmith::Gems::Loader.call Bundler.root.join("spec/support/fixtures/gemsmith-test.gemspec")
  end

  before do
    container.enable_stubs!
    container.stub :configuration, configuration
    container.stub :kernel, kernel
    container.stub :executor, executor
  end

  after do
    container.unstub :configuration
    container.unstub :kernel
    container.unstub :executor
  end
end
