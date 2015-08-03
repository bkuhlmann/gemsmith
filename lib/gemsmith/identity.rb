module Gemsmith
  module Identity
    def self.name
      "gemsmith"
    end

    def self.label
      "Gemsmith"
    end

    def self.version
      "5.3.0"
    end

    def self.label_version
      [label, version].join " "
    end
  end
end
