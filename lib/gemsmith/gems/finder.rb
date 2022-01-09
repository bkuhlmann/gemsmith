# frozen_string_literal: true

module Gemsmith
  module Gems
    # Finds multiple versions of an installed gem (if any) and answers found specifications.
    class Finder
      def self.call(path, ...) = new(...).call path

      def initialize client: ::Gem::Specification, presenter: Gems::Presenter
        @client = client
        @presenter = presenter
      end

      def call(name) = client.find_all_by_name(name).map { |record| presenter.new record }

      private

      attr_reader :client, :presenter
    end
  end
end
