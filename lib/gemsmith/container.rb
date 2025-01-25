# frozen_string_literal: true

require "cogger"
require "containable"
require "etcher"
require "open3"
require "runcom"
require "spek"

module Gemsmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Containable

    register :registry, as: :fresh do
      contract = Rubysmith::Configuration::Contract
      model = Rubysmith::Configuration::Model

      Etcher::Registry.new(contract:, model:)
                      .add_loader(:yaml, self[:defaults_path])
                      .add_loader(:yaml, self[:xdg_config].active)
                      .add_transformer(Rubysmith::Configuration::Transformers::GitHubUser.new)
                      .add_transformer(Rubysmith::Configuration::Transformers::GitEmail.new)
                      .add_transformer(Rubysmith::Configuration::Transformers::GitUser.new)
                      .add_transformer(Rubysmith::Configuration::Transformers::TemplateRoot.new)
                      .add_transformer(
                        Rubysmith::Configuration::Transformers::TemplateRoot.new(
                          default: Pathname(__dir__).join("templates")
                        )
                      )
                      .add_transformer(:root, :target_root)
                      .add_transformer(:format, :author_uri)
                      .add_transformer(:format, :citation_affiliation)
                      .add_transformer(:format, :project_uri_community)
                      .add_transformer(:format, :project_uri_conduct)
                      .add_transformer(:format, :project_uri_contributions)
                      .add_transformer(:format, :project_uri_dcoo)
                      .add_transformer(:format, :project_uri_download, :project_name)
                      .add_transformer(:format, :project_uri_funding)
                      .add_transformer(:format, :project_uri_home, :project_name)
                      .add_transformer(:format, :project_uri_issues, :project_name)
                      .add_transformer(:format, :project_uri_license)
                      .add_transformer(:format, :project_uri_security)
                      .add_transformer(:format, :project_uri_source, :project_name)
                      .add_transformer(:format, :project_uri_versions, :project_name)
                      .add_transformer(:time, :loaded_at)
    end

    register(:settings) { Etcher.call(self[:registry]).dup }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../gemsmith.gemspec" }
    register(:defaults_path) { Rubysmith::Container[:defaults_path] }
    register(:xdg_config) { Runcom::Config.new "gemsmith/configuration.yml" }
    register :environment, ENV
    register(:logger) { Cogger.new id: :gemsmith }
    register :executor, Open3
    register :io, STDOUT
  end
end
