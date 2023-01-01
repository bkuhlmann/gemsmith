# frozen_string_literal: true

module Gemsmith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit
        include Import[:specification]

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder, **dependencies
          super(**dependencies)

          @configuration = configuration
          @builder = builder
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

        attr_reader :configuration, :builder

        def body
          "Generated with [#{specification.label}](#{specification.homepage_url}) " \
          "#{specification.version}."
        end

        def project_name = configuration.project_name
      end
    end
  end
end
