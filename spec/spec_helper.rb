require "bundler/setup"

if ENV["CI"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "gemsmith"
require "gemsmith/cli"

Dir[File.join(File.dirname(__FILE__), "support/extensions/**/*.rb")].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), "support/kit/**/*.rb")].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), "support/shared_examples/**/*.rb")].each { |file| require file }
