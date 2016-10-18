# frozen_string_literal: true

require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"
require "gemsmith/errors/base"
require "gemsmith/errors/requirement_conversion"
require "gemsmith/errors/requirement_operator"
require "gemsmith/errors/specification"
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
require "gemsmith/skeletons/rails_skeleton"
require "gemsmith/skeletons/rake_skeleton"
require "gemsmith/skeletons/rspec_skeleton"
require "gemsmith/skeletons/rubocop_skeleton"
require "gemsmith/skeletons/ruby_skeleton"
require "gemsmith/skeletons/travis_skeleton"
require "gemsmith/cli_helpers"
require "gemsmith/configuration"
require "gemsmith/git"

module Gemsmith
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions
    include CLIHelpers

    package_name Gemsmith::Identity.version_label

    # Overwrites the Thor template source root.
    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "templates")
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
        Skeletons::GitSkeleton
      ]
    end

    # Initialize.
    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = Configuration.new
      @gem_spec = Gem::Specification
    end

    desc "-g, [--generate=GENERATE]", "Generate new gem."
    map %w[-g --generate] => :generate
    method_option :cli, aliases: "-c", desc: "Add CLI support.", type: :boolean, default: false
    method_option :rails, aliases: "-r", desc: "Add Rails support.", type: :boolean, default: false
    method_option :security, aliases: "-S", desc: "Add security support.", type: :boolean, default: true
    method_option :pry, aliases: "-p", desc: "Add Pry support.", type: :boolean, default: true
    method_option :guard, aliases: "-g", desc: "Add Guard support.", type: :boolean, default: true
    method_option :rspec, aliases: "-s", desc: "Add RSpec support.", type: :boolean, default: true
    method_option :rubocop, aliases: "-R", desc: "Add Rubocop support.", type: :boolean, default: true
    method_option :git_hub, aliases: "-H", desc: "Add GitHub support.", type: :boolean, default: false
    method_option :code_climate, aliases: "-C", desc: "Add Code Climate support.", type: :boolean, default: true
    method_option :gemnasium, aliases: "-G", desc: "Add Gemnasium support.", type: :boolean, default: true
    method_option :travis, aliases: "-t", desc: "Add Travis CI support.", type: :boolean, default: true
    method_option :patreon, aliases: "-P", desc: "Add Patreon support.", type: :boolean, default: true
    def generate name
      say
      info "Generating gem..."

      setup_configuration name, options
      self.class.skeletons.each { |skeleton| skeleton.create self, configuration: configuration }

      info "Gem generation finished."
      say
    end

    desc "-o, [--open=OPEN]", "Open a gem in default editor."
    map %w[-o --open] => :open
    def open name
      result = process_gem name, "open_gem"
      info("Opening: #{result}") unless result.nil? || result.empty?
    end

    desc "-r, [--read=READ]", "Open a gem in default browser."
    map %w[-r --read] => :read
    def read name
      result = process_gem name, "open_homepage"

      if result.nil? || result.empty?
        error "Gem home page is not defined."
      else
        info "Reading: #{result}"
      end
    end

    desc "-e, [--edit]", "Edit gem settings in default editor."
    map %w[-e --edit] => :edit
    def edit
      info "Editing: #{configuration.file_path}..."
      `#{gem_spec.editor} #{configuration.file_path}`
    end

    desc "-v, [--version]", "Show gem version."
    map %w[-v --version] => :version
    def version
      say Gemsmith::Identity.version_label
    end

    desc "-h, [--help=HELP]", "Show this message or get help for a command."
    map %w[-h --help] => :help
    def help task = nil
      say and super
    end

    private

    attr_reader :configuration, :gem_spec

    def setup_configuration name, options
      @configuration = Configuration.new gem_name: name, gem_class: name
      options.each { |key, value| configuration.public_send "create_#{key}=", value }
    end
  end
end
