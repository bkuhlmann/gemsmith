# frozen_string_literal: true

module Gemsmith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit
        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder, container: Container
          @configuration = configuration
          @builder = builder
          @container = container
        end

        def call
          return configuration unless configuration.build_git

          builder.call(configuration)
                 .run("git add .", chdir: project_name)
                 .run(
                   %(git commit --all --message "Added project skeleton" --message "#{body}"),
                   chdir: project_name
                 )

          configuration
        end

        private

        attr_reader :configuration, :builder, :container

        def body
          <<~CONTENT
            Generated with [#{specification.label}](#{specification.homepage_url})
            #{specification.version}.
          CONTENT
        end

        def project_name = configuration.project_name

        def specification = container[__method__]
      end
    end
  end
end
