# frozen_string_literal: true

require "runcom"

module Gemsmith
  module Configuration
    # Represents the fully assembled Command Line Interface (CLI) configuration.
    class Loader < Rubysmith::Configuration::Loader
      DEFAULTS = Rubysmith::Configuration::Loader::DEFAULTS
      CLIENT = Runcom::Config.new "gemsmith/configuration.yml", defaults: DEFAULTS

      def self.with_overrides
        new client: DEFAULTS,
            enhancers: {template_root: Rubysmith::Configuration::Enhancers::TemplateRoot}
      end

      def initialize(client: CLIENT, **) = super

      def call
        return super unless enhancers.key? :template_root

        enhancers[:template_root].call(super, overrides: Pathname(__dir__).join("../templates"))
                                 .freeze
      end
    end
  end
end
