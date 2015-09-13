module Gemsmith
  # The canonical source of gem information.
  module Identity
    def self.name
      "gemsmith"
    end

    def self.label
      "Gemsmith"
    end

    def self.version
      "5.4.0"
    end

    def self.label_version
      [label, version].join " "
    end

    def self.file_name
      ".#{name}rc"
    end
  end
end
