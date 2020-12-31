# frozen_string_literal: true

require "git_plus"
require "thor"
require "thor/actions"
require "refinements/strings"
require "refinements/hashes"
require "runcom"
require "gemsmith/helpers/cli"
require "gemsmith/helpers/template"
require "pathname"

module Gemsmith
  # The Command Line Interface (CLI) for the gem.
  # rubocop:disable Metrics/ClassLength
  class CLI < Thor
    include Thor::Actions
    include Helpers::CLI
    include Helpers::Template

    using Refinements::Strings
    using Refinements::Hashes

    package_name Identity::VERSION_LABEL

    # Overwrites Thor's template source root.
    def self.source_root
      Pathname(__dir__).join("templates").freeze
    end

    # rubocop:disable Metrics/MethodLength
    def self.configuration
      repository = GitPlus::Repository.new

      Runcom::Config.new "#{Identity::NAME}/configuration.yml",
                         defaults: {
                           year: Time.now.year,
                           github_user: repository.config_get("github.user"),
                           gem: {
                             label: "Undefined",
                             name: "undefined",
                             path: "undefined",
                             class: "Undefined",
                             platform: "Gem::Platform::RUBY",
                             url: "",
                             license: "MIT"
                           },
                           author: {
                             name: repository.config_get("user.name"),
                             email: repository.config_get("user.email"),
                             url: ""
                           },
                           organization: {
                             name: "",
                             url: ""
                           },
                           versions: {
                             ruby: RUBY_VERSION,
                             rails: "6.1"
                           },
                           generate: {
                             bundler_audit: true,
                             circle_ci: false,
                             cli: false,
                             git_lint: true,
                             git_hub: false,
                             guard: true,
                             pry: true,
                             engine: false,
                             reek: true,
                             rspec: true,
                             rubocop: true,
                             simple_cov: true,
                             security: false
                           },
                           publish: {
                             sign: false
                           }
                         }
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def self.generators
      [
        Generators::Gem,
        Generators::Documentation,
        Generators::Rake,
        Generators::CLI,
        Generators::Ruby,
        Generators::Engine,
        Generators::Rspec,
        Generators::BundlerAudit,
        Generators::GitLint,
        Generators::Reek,
        Generators::Guard,
        Generators::CircleCI,
        Generators::Bundler,
        Generators::GitHub,
        Generators::Pragma,
        Generators::Rubocop,
        Generators::Git
      ]
    end
    # rubocop:enable Metrics/MethodLength

    # Initialize.
    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = self.class.configuration
    rescue Runcom::Errors::Base => error
      abort error.message
    end

    desc "-g, [--generate=GEM]", "Generate new gem."
    map %w[-g --generate] => :generate
    method_option :bundler_audit,
                  desc: "Add Bundler Audit support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :bundler_audit)
    method_option :circle_ci,
                  desc: "Add Circle CI support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :circle_ci)
    method_option :cli,
                  desc: "Add CLI support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :cli)
    method_option :engine,
                  desc: "Add Rails Engine support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :engine)
    method_option :git_lint,
                  desc: "Add Git Lint support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :git_lint)
    method_option :git_hub,
                  desc: "Add GitHub support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :git_hub)
    method_option :guard,
                  desc: "Add Guard support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :guard)
    method_option :pry,
                  desc: "Add Pry support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :pry)
    method_option :reek,
                  desc: "Add Reek support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :reek)
    method_option :rspec,
                  desc: "Add RSpec support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :rspec)
    method_option :rubocop,
                  desc: "Add Rubocop support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :rubocop)
    method_option :simple_cov,
                  desc: "Add SimpleCov support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :simple_cov)
    method_option :security,
                  desc: "Add security support.",
                  type: :boolean,
                  default: configuration.to_h.dig(:generate, :security)
    # :reek:TooManyStatements
    def generate name
      print_cli_and_rails_engine_option_error && return if options.cli? && options.engine?

      say_status :info, "Generating gem...", :green

      setup_configuration name: name, options: options.to_h
      self.class.generators.each { |generator| generator.run self, configuration: configuration }

      say_status :info, "Gem generation finished.", :green
    end

    desc "-o, [--open=GEM]", "Open a gem in default editor."
    map %w[-o --open] => :open
    def open name
      process_gem name, "edit"
    end

    desc "-r, [--read=GEM]", "Open a gem in default browser."
    map %w[-r --read] => :read
    def read name
      say_status :error, "Gem home page is not defined.", :red unless process_gem name, "visit"
    end

    desc "-c, [--config]", "Manage gem configuration."
    map %w[-c --config] => :config
    method_option :edit,
                  aliases: "-e",
                  desc: "Edit gem configuration.",
                  type: :boolean,
                  default: false
    method_option :info,
                  aliases: "-i",
                  desc: "Print gem configuration.",
                  type: :boolean,
                  default: false
    def config
      path = configuration.current

      if options.edit? then `#{ENV["EDITOR"]} #{path}`
      elsif options.info?
        path ? say(path) : say("Configuration doesn't exist.")
      else help :config
      end
    end

    desc "-v, [--version]", "Show gem version."
    map %w[-v --version] => :version
    def version
      say Identity::VERSION_LABEL
    end

    desc "-h, [--help=COMMAND]", "Show this message or get help for a command."
    map %w[-h --help] => :help
    def help task = nil
      say and super
    end

    private

    attr_reader :configuration

    # :reek:FeatureEnvy
    # rubocop:disable Metrics/MethodLength
    def setup_configuration name:, options: {}
      repository = GitPlus::Repository.new

      @configuration = configuration.to_h.merge(
        gem: {
          label: name.titleize,
          name: name,
          path: name.snakecase,
          class: name.camelcase,
          platform: "Gem::Platform::RUBY",
          url: %(https://github.com/#{repository.config_get "github.user"}/#{name}),
          license: "MIT"
        },
        generate: options.symbolize_keys
      )
    end
    # rubocop:enable Metrics/MethodLength

    def print_cli_and_rails_engine_option_error
      say_status :error,
                 "Generating a gem with CLI and Rails Engine functionality is not allowed. " \
                 "Build separate gems for improved separation of concerns and design.",
                 :red
    end
  end
  # rubocop:enable Metrics/ClassLength
end
