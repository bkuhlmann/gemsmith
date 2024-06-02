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

    register :registry do
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
                      .add_transformer(Rubysmith::Configuration::Transformers::TargetRoot)
                      .add_transformer(:time)
    end

    register(:settings) { Etcher.call(self[:registry]).dup }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../gemsmith.gemspec" }
    register(:defaults_path) { Rubysmith::Container[:defaults_path] }
    register(:xdg_config) { Runcom::Config.new "gemsmith/configuration.yml" }
    register :environment, ENV
    register(:logger) { Cogger.new id: :gemsmith }
    register :executor, Open3
    register :kernel, Kernel
  end
end
