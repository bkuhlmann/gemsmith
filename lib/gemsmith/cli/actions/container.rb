# frozen_string_literal: true

require "dry/container"

module Gemsmith
  module CLI
    module Actions
      # Provides a single container with application and action specific dependencies.
      module Container
        extend Dry::Container::Mixin

        config.registry = ->(container, key, value, _options) { container[key.to_s] = value }

        merge Gemsmith::Container

        register(:config) { Config.new }
        register(:build) { Build.new }
        register(:install) { Install.new }
        register(:publish) { Publish.new }
        register(:edit) { Edit.new }
        register(:view) { View.new }
      end
    end
  end
end
