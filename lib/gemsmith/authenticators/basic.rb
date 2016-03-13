# frozen_string_literal: true

require "net/http"

module Gemsmith
  module Authenticators
    # An authenticator for retrieving HTTP Basic authorization.
    class Basic
      def self.url
        ""
      end

      def initialize login, password, encrypter: Net::HTTP::Get.new("https://ignore.example.com")
        @login = login
        @password = password
        @encrypter = encrypter
      end

      def authorization
        encrypter.basic_auth(login, password).first
      end

      private

      attr_reader :login, :password, :encrypter
    end
  end
end
