require "dry-container"
require "logger"
require "pastel"
require "spek"

module Test
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register(:configuration) { Configuration::Loader.call }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../test.gemspec" }
    register(:colorizer) { Pastel.new enabled: $stdout.tty? }
    register(:kernel) { Kernel }

    register :log_colors do
      {
        "DEBUG" => self[:colorizer].white.detach,
        "INFO" => self[:colorizer].green.detach,
        "WARN" => self[:colorizer].yellow.detach,
        "ERROR" => self[:colorizer].red.detach,
        "FATAL" => self[:colorizer].white.bold.on_red.detach,
        "ANY" => self[:colorizer].white.bold.detach
      }
    end

    register :logger do
      Logger.new $stdout,
                 level: Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO")),
                 formatter: (
                   lambda do |severity, _at, _name, message|
                     self[:log_colors][severity].call "#{message}\n"
                   end
                 )
    end
  end
end
