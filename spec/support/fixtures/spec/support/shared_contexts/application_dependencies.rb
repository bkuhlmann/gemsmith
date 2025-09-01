RSpec.shared_context "with application dependencies" do
  using Refinements::Struct

  let(:settings) { Test::Container[:settings] }
  let(:logger) { Cogger.new id: "test", io: StringIO.new, level: :debug }
  let(:io) { StringIO.new }

  before do
    settings.with! Etcher.call(Test::Container[:registry].remove_loader(1))
    Test::Container.stub! logger:, io:
  end

  after { Test::Container.restore }
end
