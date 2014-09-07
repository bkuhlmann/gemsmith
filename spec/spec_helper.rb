require "bundler/setup"

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "gemsmith"
require "gemsmith/cli"
require "pry"
require "pry-remote"
require "pry-rescue"

case Gem.ruby_engine
  when "ruby"
    require "pry-byebug"
    require "pry-stack_explorer"
  when "jruby"
    require "pry-nav"
  when "rbx"
    require "pry-nav"
    require "pry-stack_explorer"
end

Dir[File.join(File.dirname(__FILE__), "support/kit/**/*.rb")].each { |file| require file }

RSpec.configure do |config|
  # NOTE: Add Gemsmith specific configuration here. For the common configuration, see the "support/kit" folder.
end
