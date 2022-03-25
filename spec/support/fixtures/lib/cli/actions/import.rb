require "auto_injector"

module Test
  module CLI
    module Actions
      Import = AutoInjector[Container]
    end
  end
end
