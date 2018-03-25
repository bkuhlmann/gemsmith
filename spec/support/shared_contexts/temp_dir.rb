# frozen_string_literal: true

RSpec.shared_context "Temporary Directory", :temp_dir do
  let(:temp_dir) { Bundler.root.join "tmp", "rspec" }

  around do |example|
    FileUtils.mkdir_p temp_dir
    example.run
    FileUtils.rm_rf temp_dir
  end
end
