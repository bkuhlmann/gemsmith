RSpec.configure do |config|
  temp_dir = File.expand_path "../../../../tmp/rspec", __FILE__

  config.before :suite do
    FileUtils.rm_rf(temp_dir) if File.exist?(temp_dir)
    FileUtils.mkdir_p(temp_dir) unless File.exist?(temp_dir)
  end

  config.after :suite do
    FileUtils.rm_rf(temp_dir) if File.exist?(temp_dir)
  end
end
