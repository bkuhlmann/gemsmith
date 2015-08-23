if ENV["SUPPRESS_STDOUT"] == "enabled"
  RSpec.configure do |config|
    stdout_original = $stdout
    config.before(:suite) { $stdout = File.new "/dev/null", "w" }
    config.after(:suite) { $stdout = stdout_original }
  end
end
