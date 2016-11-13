# frozen_string_literal: true

module Gemsmith
  module Helpers
    # Provides helper methods for use by the Thor CLI. These methods are necessary to resolve %% file
    # and folder variables and render dynamic content within the Thor ERB *templates* structure.
    module Template
      def gem_name
        configuration.dig :gem, :name
      end

      def gem_path
        configuration.dig :gem, :path
      end

      def gem_class
        configuration.dig :gem, :class
      end

      def rails_version
        configuration.dig :versions, :rails
      end

      def render_namespace &block
        body = capture(&block) if block_given?
        concat Gem::ModuleFormatter.new(gem_class).render(body)
      end
    end
  end
end
