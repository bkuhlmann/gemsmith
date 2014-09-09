require "rspec/core/shared_context"

module RSpecSupportKitTempDirContext
  extend RSpec::Core::SharedContext
  let (:temp_dir) { File.expand_path "../../../../tmp/rspec", __FILE__ }
end

RSpec.configure do |config|
  config.include RSpecSupportKitTempDirContext

  config.before do |example|
    if example.metadata[:temp_dir]
      FileUtils.rm_rf(temp_dir) if File.exist?(temp_dir)
      FileUtils.mkdir_p(temp_dir)
    end
  end
end
