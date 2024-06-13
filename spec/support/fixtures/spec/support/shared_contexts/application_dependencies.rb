RSpec.shared_context "with application dependencies" do
  using Refinements::Struct

  let(:settings) { Test::Container[:settings] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: "test", io: StringIO.new, level: :debug }

  before do
    settings.merge! Etcher.call(Test::Container[:registry].remove_loader(1))
    Test::Container.stub! kernel:, logger:
  end

  after { Test::Container.restore }
end
