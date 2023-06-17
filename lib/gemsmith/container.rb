# frozen_string_literal: true

require "cogger"
require "dry-container"
require "etcher"
require "open3"
require "runcom"
require "spek"

module Gemsmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register :configuration do
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self[:xdg_config].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults do
      registry = Etcher::Registry.new contract: Rubysmith::Configuration::Contract,
                                      model: Rubysmith::Configuration::Model

      registry.add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
              .add_transformer(Rubysmith::Configuration::Transformers::CurrentTime)
              .add_transformer(Rubysmith::Configuration::Transformers::GitHubUser.new)
              .add_transformer(Rubysmith::Configuration::Transformers::GitEmail.new)
              .add_transformer(Rubysmith::Configuration::Transformers::GitUser.new)
              .add_transformer(Rubysmith::Configuration::Transformers::TemplateRoot.new)
              .add_transformer(
                Rubysmith::Configuration::Transformers::TemplateRoot.new(
                  Pathname(__dir__).join("templates")
                )
              )
              .add_transformer(Rubysmith::Configuration::Transformers::TargetRoot)
    end

    register(:input, memoize: true) { self[:configuration].dup }
    register(:defaults_path) { Rubysmith::Container[:defaults_path] }
    register(:xdg_config) { Runcom::Config.new "gemsmith/configuration.yml" }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../gemsmith.gemspec" }
    register(:environment) { ENV }
    register(:executor) { Open3 }
    register(:kernel) { Kernel }
    register(:logger) { Cogger.new formatter: :emoji }
  end
end
