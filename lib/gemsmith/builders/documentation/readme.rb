# frozen_string_literal: true

require "refinements/struct"

module Gemsmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Rubysmith::Builders::Documentation::Readme
        using Refinements::Struct

        def call
          return false unless settings.build_readme

          super
          builder.call(settings.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .replace(/Setup.+Usage/m, setup)
                 .replace("Rubysmith", "Gemsmith")
                 .replace("rubysmith", "gemsmith")

          true
        end

        private

        def setup = kind == "adoc" ? ascii_setup : markdown_setup

        def ascii_setup = settings.build_security ? ascii_secure : ascii_insecure

        def ascii_secure
          project_name = settings.project_name

          <<~CONTENT.strip
            Setup

            To install _with_ security, run:

            [source,bash]
            ----
            # 💡 Skip this line if you already have the public certificate installed.
            gem cert --add <(curl --compressed --location #{settings.organization_uri}/gems.pem)
            gem install #{project_name} --trust-policy HighSecurity
            ----

            To install _without_ security, run:

            [source,bash]
            ----
            gem install #{project_name}
            ----

            #{ascii_common}
          CONTENT
        end

        def ascii_insecure
          <<~CONTENT.strip
            Setup

            To install, run:

            [source,bash]
            ----
            gem install #{settings.project_name}
            ----

            #{ascii_common}
          CONTENT
        end

        def ascii_common
          <<~CONTENT.strip
            You can also add the gem directly to your project:

            [source,bash]
            ----
            bundle add #{settings.project_name}
            ----

            Once the gem is installed, you only need to require it:

            [source,ruby]
            ----
            require "#{settings.project_path}"
            ----

            == Usage
          CONTENT
        end

        def markdown_setup = settings.build_security ? markdown_secure : markdown_insecure

        def markdown_secure
          project_name = settings.project_name

          <<~CONTENT.strip
            Setup

            To install _with_ security, run:

                # 💡 Skip this line if you already have the public certificate installed.
                gem cert --add <(curl --compressed --location #{settings.organization_uri}/gems.pem)
                gem install #{project_name} --trust-policy HighSecurity

            To install _without_ security, run:

                gem install #{project_name}

            #{markdown_common}
          CONTENT
        end

        def markdown_insecure
          <<~CONTENT.strip
            Setup

            To install, run:

                gem install #{settings.project_name}

            #{markdown_common}
          CONTENT
        end

        def markdown_common
          <<~CONTENT.strip
            You can also add the gem directly to your project:

                bundle add #{settings.project_name}

            Once the gem is installed, you only need to require it:

                require "#{settings.project_path}"

            ## Usage
          CONTENT
        end
      end
    end
  end
end
