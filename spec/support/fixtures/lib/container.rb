require "cogger"
require "containable"
require "etcher"
require "runcom"
require "spek"

module Test
  # Provides a global gem container for injection into other objects.
  module Container
    extend Containable

    register :configuration do
      self[:defaults].add_loader(:yaml, self[:xdg_config].active)
                     .then { |registry| Etcher.call registry }
    end

    register :defaults do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(:yaml, self[:defaults_path])
    end

    register(:specification) { Spek::Loader.call "#{__dir__}/../../test.gemspec" }
    register(:defaults_path) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:xdg_config) { Runcom::Config.new "test/configuration.yml" }
    register(:logger) { Cogger.new id: "test" }
    register :kernel, Kernel
  end
end
