require "cogger"
require "dry/container"
require "etcher"
require "runcom"
require "spek"

module Test
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register :configuration, memoize: true do
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self[:xdg_config].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults, memoize: true do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
    end

    register :specification, memoize: true do
      Spek::Loader.call "#{__dir__}/../../test.gemspec"
    end

    register(:defaults_path, memoize: true) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:xdg_config, memoize: true) { Runcom::Config.new "test/configuration.yml" }
    register(:logger, memoize: true) { Cogger.new id: "test" }
    register :kernel, Kernel
  end
end
