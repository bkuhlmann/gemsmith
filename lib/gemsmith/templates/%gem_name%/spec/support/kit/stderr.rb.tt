if ENV["SUPPRESS_STDERR"] == "enabled"
  RSpec.configure do |config|
    stderr_original = $stderr
    config.before(:suite) { $stderr = File.new "/dev/null", "w" }
    config.after(:suite) { $stderr = stderr_original }
  end
end
