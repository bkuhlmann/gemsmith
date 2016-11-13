# frozen_string_literal: true

require "thor"
require "thor/actions"
require "thor_plus/actions"
require "refinements/strings"
require "refinements/hashes"
require "runcom"
require "gemsmith/cli_helpers"
require "gemsmith/template_helper"

module Gemsmith
  # The Command Line Interface (CLI) for the gem.
  # rubocop:disable Metrics/ClassLength
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions
    include CLIHelpers
    include TemplateHelper

    using Refinements::Strings
    using Refinements::Hashes

    package_name Identity.version_label

    # Overwrites Thor's template source root.
    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "templates")
    end

    def self.configuration
      Runcom::Configuration.new file_name: Identity.file_name, defaults: {
        year: Time.now.year,
        github_user: Git.github_user,
        gem: {
          name: "undefined",
          path: "undefined",
          class: "Undefined",
          platform: "Gem::Platform::RUBY",
          url: Git.github_url("undefined"),
          license: "MIT"
        },
        author: {
          name: Git.config_value("user.name"),
          email: Git.config_value("user.email"),
          url: ""
        },
        organization: {
          name: "",
          url: ""
        },
        versions: {
          ruby: RUBY_VERSION,
          rails: "5.0"
        },
        generate: {
          cli: false,
          rails: false,
          security: true,
          pry: true,
          guard: true,
          rspec: true,
          reek: true,
          rubocop: true,
          scss_lint: false,
          git_hub: false,
          code_climate: false,
          gemnasium: false,
          travis: false,
          patreon: false
        },
        publish: {
          sign: false
        }
      }
    end

    def self.generators
      [
        Generators::Gem,
        Generators::Documentation,
        Generators::Rake,
        Generators::CLI,
        Generators::Ruby,
        Generators::Rails,
        Generators::Rspec,
        Generators::Reek,
        Generators::Rubocop,
        Generators::SCSSLint,
        Generators::CodeClimate,
        Generators::Guard,
        Generators::Travis,
        Generators::Bundler,
        Generators::GitHub,
        Generators::Pragma,
        Generators::Git
      ]
    end

    # Initialize.
    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = {}
    end

    desc "-g, [--generate=GEM]", "Generate new gem."
    map %w[-g --generate] => :generate
    method_option :cli,
                  desc: "Add CLI support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :cli)
    method_option :rails,
                  desc: "Add Rails support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :rails)
    method_option :security,
                  desc: "Add security support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :security)
    method_option :pry,
                  desc: "Add Pry support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :pry)
    method_option :guard,
                  desc: "Add Guard support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :guard)
    method_option :rspec,
                  desc: "Add RSpec support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :rspec)
    method_option :reek,
                  desc: "Add Reek support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :reek)
    method_option :rubocop,
                  desc: "Add Rubocop support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :rubocop)
    method_option :scss_lint,
                  desc: "Add SCSS Lint support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :scss_lint)
    method_option :git_hub,
                  desc: "Add GitHub support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :git_hub)
    method_option :code_climate,
                  desc: "Add Code Climate support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :code_climate)
    method_option :gemnasium,
                  desc: "Add Gemnasium support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :gemnasium)
    method_option :travis,
                  desc: "Add Travis CI support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :travis)
    method_option :patreon,
                  desc: "Add Patreon support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :patreon)
    def generate name
      say
      info "Generating gem..."

      setup_configuration name: name, options: options
      self.class.generators.each { |generator| generator.run self, configuration: configuration }

      info "Gem generation finished."
      say
    end

    desc "-o, [--open=GEM]", "Open a gem in default editor."
    map %w[-o --open] => :open
    def open name
      process_gem name, "edit"
    end

    desc "-r, [--read=GEM]", "Open a gem in default browser."
    map %w[-r --read] => :read
    def read name
      error "Gem home page is not defined." unless process_gem(name, "visit")
    end

    desc "-c, [--config]", %(Manage gem configuration ("#{configuration.computed_path}").)
    map %w[-c --config] => :config
    method_option :edit,
                  aliases: "-e",
                  desc: "Edit gem configuration.",
                  type: :boolean, default: false
    method_option :info,
                  aliases: "-i",
                  desc: "Print gem configuration.",
                  type: :boolean, default: false
    def config
      path = self.class.configuration.computed_path

      if options.edit? then `#{editor} #{path}`
      elsif options.info? then say(path)
      else help(:config)
      end
    end

    desc "-v, [--version]", "Show gem version."
    map %w[-v --version] => :version
    def version
      say Identity.version_label
    end

    desc "-h, [--help=COMMAND]", "Show this message or get help for a command."
    map %w[-h --help] => :help
    def help task = nil
      say and super
    end

    private

    attr_reader :configuration

    def setup_configuration name:, options: {}
      symbolized_options = options.reduce({}) do |new_options, (key, value)|
        new_options.merge! key.to_sym => value
      end

      @configuration = self.class.configuration.to_h.merge(
        gem: {
          name: name,
          path: name.snakecase,
          class: name.camelcase,
          platform: "Gem::Platform::RUBY",
          url: Git.github_url(name),
          license: "MIT"
        },
        generate: symbolized_options
      )
    end
  end
end
