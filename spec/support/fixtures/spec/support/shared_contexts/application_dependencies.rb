RSpec.shared_context "with application dependencies" do
  let(:configuration) { Etcher.new(Test::Container[:defaults]).call.bind(&:dup) }
  let(:xdg_config) { Runcom::Config.new Test::Container[:defaults_path] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: "test", io: StringIO.new, level: :debug }

  before { Test::Container.stub! configuration:, xdg_config:, kernel:, logger: }
  after { Test::Container.restore }
end
