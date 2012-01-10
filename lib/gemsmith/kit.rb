module Gemsmith
  # Provides supplementary utility methods.
  class Kit
    # Answers the git config (i.e. ~/.gitconfig) value for a given key, otherwise nil.
    # ==== Parameters
    # # * +key+ - Required. The git config key to search for.
    def self.git_config_value key
      value = `git config #{key}`.chomp
      value.nil? || value.empty? ? nil : value
    end
  end
end