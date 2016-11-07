# frozen_string_literal: true

require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"
require "refinements/strings"
require "refinements/hashes"
require "runcom"
require "gemsmith/errors/base"
require "gemsmith/errors/requirement_conversion"
require "gemsmith/errors/requirement_operator"
require "gemsmith/errors/specification"
require "gemsmith/gem/inspector"
require "gemsmith/gem/module_formatter"
require "gemsmith/gem/requirement"
require "gemsmith/gem/specification"
require "gemsmith/skeletons/base_skeleton"
require "gemsmith/skeletons/bundler_skeleton"
require "gemsmith/skeletons/cli_skeleton"
require "gemsmith/skeletons/documentation_skeleton"
require "gemsmith/skeletons/gem_skeleton"
require "gemsmith/skeletons/git_skeleton"
require "gemsmith/skeletons/git_hub_skeleton"
require "gemsmith/skeletons/guard_skeleton"
require "gemsmith/skeletons/pragma_skeleton"
require "gemsmith/skeletons/rails_skeleton"
require "gemsmith/skeletons/rake_skeleton"
require "gemsmith/skeletons/rspec_skeleton"
require "gemsmith/skeletons/rubocop_skeleton"
require "gemsmith/skeletons/ruby_skeleton"
require "gemsmith/skeletons/travis_skeleton"
require "gemsmith/cli_helpers"
require "gemsmith/git"

module Gemsmith
  # The Command Line Interface (CLI) for the gem.
  # rubocop:disable Metrics/ClassLength
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions
    include CLIHelpers

    using Refinements::Strings
    using Refinements::Hashes

    package_name Gemsmith::Identity.version_label

    # Overwrites the Thor template source root.
    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "templates")
    end

    def self.defaults
      {
        year: Time.now.year,
        github_user: Git.github_user,
        gem: {
          name: "undefined",
          path: "undefined",
          class: "Undefined",
          platform: "Gem::Platform::RUBY",
          home_url: Git.github_url("undefined"),
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
        create: {
          cli: false,
          rails: false,
          security: true,
          pry: true,
          guard: true,
          rspec: true,
          rubocop: true,
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

    def self.skeletons
      [
        Skeletons::GemSkeleton,
        Skeletons::DocumentationSkeleton,
        Skeletons::RakeSkeleton,
        Skeletons::CLISkeleton,
        Skeletons::RubySkeleton,
        Skeletons::RailsSkeleton,
        Skeletons::RspecSkeleton,
        Skeletons::RubocopSkeleton,
        Skeletons::GuardSkeleton,
        Skeletons::TravisSkeleton,
        Skeletons::BundlerSkeleton,
        Skeletons::GitHubSkeleton,
        Skeletons::PragmaSkeleton,
        Skeletons::GitSkeleton
      ]
    end

    # Initialize.
    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = Runcom::Configuration.new file_name: Identity.file_name, defaults: self.class.defaults
      @generator_configuration = {}
    end

    desc "-g, [--generate=GEM]", "Generate new gem."
    map %w[-g --generate] => :generate
    method_option :cli, aliases: "-c", desc: "Add CLI support.", type: :boolean, default: false
    method_option :rails, aliases: "-r", desc: "Add Rails support.", type: :boolean, default: false
    method_option :security, aliases: "-S", desc: "Add security support.", type: :boolean, default: true
    method_option :pry, aliases: "-p", desc: "Add Pry support.", type: :boolean, default: true
    method_option :guard, aliases: "-g", desc: "Add Guard support.", type: :boolean, default: true
    method_option :rspec, aliases: "-s", desc: "Add RSpec support.", type: :boolean, default: true
    method_option :rubocop, aliases: "-R", desc: "Add Rubocop support.", type: :boolean, default: true
    method_option :git_hub, aliases: "-H", desc: "Add GitHub support.", type: :boolean, default: false
    method_option :code_climate, aliases: "-C", desc: "Add Code Climate support.", type: :boolean, default: false
    method_option :gemnasium, aliases: "-G", desc: "Add Gemnasium support.", type: :boolean, default: false
    method_option :travis, aliases: "-t", desc: "Add Travis CI support.", type: :boolean, default: false
    method_option :patreon, aliases: "-P", desc: "Add Patreon support.", type: :boolean, default: false
    def generate name
      say
      info "Generating gem..."

      configure_generators name: name, options: options
      self.class.skeletons.each { |skeleton| skeleton.create self, configuration: generator_configuration }

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
      say Gemsmith::Identity.version_label
    end

    desc "-h, [--help=COMMAND]", "Show this message or get help for a command."
    map %w[-h --help] => :help
    def help task = nil
      say and super
    end

    private

    attr_reader :configuration, :generator_configuration

    def configure_generators name:, options: {}
      symbolized_options = options.reduce({}) do |new_options, (key, value)|
        new_options.merge! key.to_sym => value
      end

      @generator_configuration = configuration.merge(
        gem: {
          name: name,
          path: name.snakecase,
          class: name.camelcase,
          home_url: Git.github_url(name)
        },
        create: symbolized_options
      )
    end
  end
end
