# frozen_string_literal: true

require "zeitwerk"
require "rubysmith"

Zeitwerk::Loader.for_gem.then do |loader|
  loader.inflector.inflect "cli" => "CLI", "circle_ci" => "CircleCI"
  loader.setup
end

# Main namespace.
module Gemsmith
end
