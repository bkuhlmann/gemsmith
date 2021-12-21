# frozen_string_literal: true

require "pathname"
require "refinements/arrays"
require "refinements/hashes"
require "refinements/structs"
require "runcom"
require "yaml"

module Gemsmith
  module Configuration
    # Represents the fully assembled Command Line Interface (CLI) configuration.
    class Loader
      using Refinements::Arrays
      using Refinements::Hashes
      using Refinements::Structs

      DEFAULTS = Rubysmith::Configuration::Loader::DEFAULTS
      CLIENT = Runcom::Config.new "gemsmith/configuration.yml", defaults: DEFAULTS

      ENHANCERS = Rubysmith::Configuration::Loader::ENHANCERS.including(Enhancers::TemplateRoot.new)
                                                             .freeze

      def self.call(...) = new(...).call

      def self.with_defaults = new(client: DEFAULTS, enhancers: [])

      def self.with_overrides = new(client: DEFAULTS, enhancers: [Enhancers::TemplateRoot.new])

      def initialize content: Rubysmith::Configuration::Content.new,
                     client: CLIENT,
                     enhancers: ENHANCERS
        @content = content
        @client = client
        @enhancers = enhancers
      end

      def call
        enhancers.reduce(preload_content) { |preload, enhancer| enhancer.call preload }
                 .freeze
      end

      private

      attr_reader :content, :client, :enhancers

      def preload_content = content.merge(**client.to_h.flatten_keys)
    end
  end
end
