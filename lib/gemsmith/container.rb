# frozen_string_literal: true

require "dry/container"
require "open3"
require "spek"

module Gemsmith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    config.registry = ->(container, key, value, _options) { container[key.to_s] = value }

    merge Rubysmith::Container

    register(:configuration) { Gemsmith::Configuration::Loader.call }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../gemsmith.gemspec" }
    register(:environment) { ENV }
    register(:executor) { Open3 }
    register(:kernel) { Kernel }
  end
end
