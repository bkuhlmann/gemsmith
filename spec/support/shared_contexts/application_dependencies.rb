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
      target_root: temp_dir,
      template_roots: [
        Bundler.root.join("lib/gemsmith/templates"),
        *Rubysmith::Container[:configuration].template_roots
      ]
    )
  end

  let(:kernel) { class_spy Kernel }
  let(:executor) { class_spy Open3, capture3: ["Output.", "Error.", Process::Status.allocate] }

  let :logger do
    Cogger::Client.new Logger.new(StringIO.new),
                       formatter: -> _severity, _name, _at, message { "#{message}\n" },
                       level: Logger::DEBUG
  end

  let :specification do
    Spek::Loader.call Bundler.root.join("spec/support/fixtures/gemsmith-test.gemspec")
  end

  before { Gemsmith::Import.stub configuration:, kernel:, executor:, logger: }

  after { Gemsmith::Import.unstub :configuration, :kernel, :executor, :logger }
end
