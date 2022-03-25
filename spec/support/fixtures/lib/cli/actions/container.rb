require "dry/container"

module Test
  module CLI
    module Actions
      # Provides a single container of application and action specific dependencies.
      module Container
        extend Dry::Container::Mixin

        config.registry = ->(container, key, value, _options) { container[key.to_s] = value }

        merge Test::Container

        register(:config) { Config.new }
      end
    end
  end
end
