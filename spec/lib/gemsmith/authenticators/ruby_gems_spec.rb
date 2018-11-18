# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Authenticators::RubyGems do
  subject(:ruby_gems) { described_class.new login, password }

  let(:login) { "admin" }
  let(:password) { "open_sesame" }
  let(:client) { instance_spy Net::HTTP }
  let(:request) { instance_spy Net::HTTP::Get }
  let(:api_key) { "b656c8cfc5b9d6d661520345b956cb16" }
  let(:response) { instance_spy Net::HTTPResponse, body: api_key }

  before do
    allow(client).to receive(:request).with(request).and_return(response)
    allow(Net::HTTP).to receive(:new).with("rubygems.org", 443).and_return(client)
    allow(Net::HTTP::Get).to receive(:new).with("/api/v1/api_key").and_return(request)
  end

  describe "#initialize" do
    before { ruby_gems }

    it "uses SSL encryption" do
      expect(client).to have_received(:use_ssl=).with(true)
    end

    it "uses verify peer mode" do
      expect(client).to have_received(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER)
    end
  end

  describe "#authorization" do
    it "uses HTTP Basic authentication" do
      ruby_gems.authorization
      expect(request).to have_received(:basic_auth).with(login, password)
    end

    it "answers API key" do
      expect(ruby_gems.authorization).to eq(api_key)
    end
  end
end
