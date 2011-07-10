module Gemsmith
  # Additional utilities for the command line.
  module Utilities
    # Prints info to the console.
    def say_info message
      say_status :info, message, :white
    end
    
    # Prints an error to the console.
    def say_error message
      say_status :error, message, :red
    end
  end
end
