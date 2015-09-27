require "rspec/core/shared_context"

module RSpec
  module Kit
    # Adds temp directory support to specs enabled with the :temp_dir metadata key.
    module TempDirContext
      extend RSpec::Core::SharedContext
      let(:temp_dir) { File.expand_path "../../../../tmp/rspec", __FILE__ }
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Kit::TempDirContext

  config.before do |example|
    FileUtils.mkdir_p(temp_dir) if example.metadata[:temp_dir]
  end

  config.after do |example|
    FileUtils.rm_rf(temp_dir) if example.metadata[:temp_dir]
  end
end
