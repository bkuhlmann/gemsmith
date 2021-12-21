# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Configuration::Enhancers::TemplateRoot do
  subject(:enhancer) { described_class.new }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Content.new }

    it "answers overrides first" do
      template_roots = enhancer.call(content).template_roots

      expect(template_roots).to match_array(
        [
          Bundler.root.join("lib/gemsmith/templates"),
          kind_of(Pathname)
        ]
      )
    end

    it "answers fallbacks with no overrides" do
      enhancer = described_class.new nil
      template_roots = enhancer.call(content).template_roots

      expect(template_roots).to contain_exactly(kind_of(Pathname))
    end
  end
end
