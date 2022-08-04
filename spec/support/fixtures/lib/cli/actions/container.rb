require "dry/container"

module Test
  module CLI
    module Actions
      # Provides a single container of application and action specific dependencies.
      module Container
        extend Dry::Container::Mixin

        merge Test::Container

        register(:config) { Config.new }
      end
    end
  end
end
