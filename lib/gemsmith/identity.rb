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
      "13.7.2"
    end

    def self.version_label
      "#{label} #{version}"
    end

    def self.url
      "https://github.com/bkuhlmann/gemsmith"
    end
  end
end
