require "rubygems"
require "bundler/setup"
require "gemsmith"
require File.join "gemsmith", "utilities"
require File.join "gemsmith", "cli"

RSpec.configure do |config|
  config.before :suite do
  end
end
