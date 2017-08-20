# frozen_string_literal: true

module Gemsmith
  # Gem identity information.
  module Identity
    def self.name
      "gemsmith"
    end

    def self.label
      "Gemsmith"
    end

    def self.version
      "10.3.0"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
