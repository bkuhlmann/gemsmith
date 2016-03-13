# frozen_string_literal: true

require "net/http"
require "uri"

module Gemsmith
  module Authenticators
    # An authenticator for retrieving RubyGems authorization.
    class RubyGems
      def self.url
        "https://rubygems.org/api/v1/api_key"
      end

      def initialize login, password
        @login = login
        @password = password
        @uri = URI.parse self.class.url
        configure_client
      end

      def authorization
        request = Net::HTTP::Get.new uri.request_uri
        request.basic_auth login, password
        response = client.request request
        String response.body
      end

      private

      attr_reader :login, :password, :uri, :client

      def configure_client
        @client = Net::HTTP.new uri.host, uri.port
        @client.use_ssl = true
        @client.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
    end
  end
end
