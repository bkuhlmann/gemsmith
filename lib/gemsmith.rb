# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect "cli" => "CLI", "circle_ci" => "CircleCI"
loader.setup

# Main namespace.
module Gemsmith
end
