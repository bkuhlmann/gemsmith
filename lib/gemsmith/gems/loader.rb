# frozen_string_literal: true

module Gemsmith
  module Gems
    # Loads a gem's specification.
    class Loader
      def self.call(path, ...) = new(...).call path

      def initialize client: ::Gem::Specification, presenter: Gems::Presenter
        warn "[DEPRECATION]: Loader is deprecated, use Spek gem instead."

        @client = client
        @presenter = presenter
      end

      def call(path) = client.load(path.to_s).then { |record| presenter.new record }

      private

      attr_reader :client, :presenter
    end
  end
end
