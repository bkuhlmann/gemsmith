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
      "7.4.0"
    end

    def self.version_label
      "#{label} #{version}"
    end

    def self.file_name
      ".#{name}rc"
    end
  end
end
