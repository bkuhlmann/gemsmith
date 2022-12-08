# frozen_string_literal: true

require "rubysmith"
require "zeitwerk"

Zeitwerk::Loader.for_gem.then do |loader|
  loader.inflector.inflect "cli" => "CLI", "circle_ci" => "CircleCI", "rspec" => "RSpec"
  loader.setup
end

# Main namespace.
module Gemsmith
end
