# frozen_string_literal: true

require "rubysmith"
require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "cli" => "CLI", "circle_ci" => "CircleCI", "rspec" => "RSpec"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Gemsmith
end
