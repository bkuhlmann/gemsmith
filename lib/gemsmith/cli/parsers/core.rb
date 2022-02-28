# frozen_string_literal: true

require "pathname"
require "refinements/structs"

module Gemsmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) core options.
      class Core
        include Import[:specification]

        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration = Container[:configuration],
                       client: Parser::CLIENT,
                       **dependencies
          super(**dependencies)

          @configuration = configuration
          @client = client
        end

        def call arguments = []
          client.banner = specification.labeled_summary
          client.separator "\nUSAGE:\n"
          collate
          client.parse arguments
          configuration
        end

        private

        attr_reader :configuration, :client

        def collate = private_methods.sort.grep(/add_/).each { |method| __send__ method }

        def add_config
          client.on "-c",
                    "--config ACTION",
                    %i[edit view],
                    "Manage gem configuration: edit or view." do |action|
            configuration.merge! action_config: action
          end
        end

        def add_build
          client.on "-b", "--build NAME [options]", "Build new project." do |name|
            configuration.merge! action_build: true, project_name: name
          end
        end

        def add_edit
          client.on "--edit GEM", "Edit installed gem in default editor." do |gem_name|
            configuration.merge! action_edit: gem_name
          end
        end

        def add_install
          client.on "-i", "--install [NAME]", "Install gem for local development." do |name|
            configuration.merge! action_install: true,
                                 project_name: name || Pathname.pwd.basename.to_s
          end
        end

        def add_publish
          client.on "-p", "--publish [NAME]", "Publish gem to remote gem server." do |name|
            configuration.merge! action_publish: true,
                                 project_name: name || Pathname.pwd.basename.to_s
          end
        end

        def add_view
          client.on "--view GEM", "View installed gem in default browser." do |gem_name|
            configuration.merge! action_view: gem_name
          end
        end

        def add_version
          client.on "-v", "--version", "Show gem version." do
            configuration.merge! action_version: true
          end
        end

        def add_help
          client.on "-h", "--help", "Show this message." do
            configuration.merge! action_help: true
          end
        end
      end
    end
  end
end
