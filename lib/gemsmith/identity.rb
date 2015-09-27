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
      "5.6.0"
    end

    def self.version_label
      [label, version].join " "
    end

    def self.file_name
      ".#{name}rc"
    end
  end
end
