# frozen_string_literal: true

RSpec.shared_context "Temporary Directory", :temp_dir do
  let(:temp_dir) { File.expand_path "../../../../tmp/rspec", __FILE__ }

  around do |example|
    FileUtils.mkdir_p temp_dir
    example.run
    FileUtils.rm_rf temp_dir
  end
end
