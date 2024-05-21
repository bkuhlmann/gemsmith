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

    register :configuration do
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self[:xdg_config].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults do
      registry = Etcher::Registry.new contract: Rubysmith::Configuration::Contract,
                                      model: Rubysmith::Configuration::Model

      registry.add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
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
              .add_transformer(Etcher::Transformers::Time.new)
    end

    register(:specification) { Spek::Loader.call "#{__dir__}/../../gemsmith.gemspec" }
    register(:input) { self[:configuration].dup }
    register(:defaults_path) { Rubysmith::Container[:defaults_path] }
    register(:xdg_config) { Runcom::Config.new "gemsmith/configuration.yml" }
    register :environment, ENV
    register(:logger) { Cogger.new id: :gemsmith }
    register :executor, Open3
    register :kernel, Kernel
  end
end
