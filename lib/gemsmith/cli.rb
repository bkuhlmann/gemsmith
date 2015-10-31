require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"
require "gemsmith/cli_options"
require "gemsmith/cli_helpers"
require "gemsmith/skeletons/base_skeleton"
require "gemsmith/skeletons/bundler_skeleton"
require "gemsmith/skeletons/cli_skeleton"
require "gemsmith/skeletons/documentation_skeleton"
require "gemsmith/skeletons/gem_skeleton"
require "gemsmith/skeletons/git_skeleton"
require "gemsmith/skeletons/guard_skeleton"
require "gemsmith/skeletons/rails_skeleton"
require "gemsmith/skeletons/rake_skeleton"
require "gemsmith/skeletons/rspec_skeleton"
require "gemsmith/skeletons/rubocop_skeleton"
require "gemsmith/skeletons/ruby_skeleton"
require "gemsmith/skeletons/travis_skeleton"

module Gemsmith
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions
    include CLIOptions
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
        Skeletons::GitSkeleton
      ]
    end

    # Initialize.
    def initialize args = [], options = {}, config = {}
      super args, options, config
      @settings_file = File.join ENV["HOME"], ".gemsmith", "settings.yml"
      @settings = load_yaml @settings_file
      @template_options = {}
    end

    desc "-c, [create=CREATE]", "Create new gem."
    map %w(-c --create) => :create
    method_option :bin, aliases: "-b", desc: "Add binary support.", type: :boolean, default: false
    method_option :rails, aliases: "-r", desc: "Add Rails support.", type: :boolean, default: false
    method_option :security, aliases: "-S", desc: "Add security support.", type: :boolean, default: true
    method_option :pry, aliases: "-p", desc: "Add Pry support.", type: :boolean, default: true
    method_option :guard, aliases: "-g", desc: "Add Guard support.", type: :boolean, default: true
    method_option :rspec, aliases: "-s", desc: "Add RSpec support.", type: :boolean, default: true
    method_option :rubocop, aliases: "-R", desc: "Add Rubocop support.", type: :boolean, default: true
    method_option :code_climate, aliases: "-c", desc: "Add Code Climate support.", type: :boolean, default: true
    method_option :gemnasium, aliases: "-G", desc: "Add Gemnasium support.", type: :boolean, default: true
    method_option :travis, aliases: "-t", desc: "Add Travis CI support.", type: :boolean, default: true
    method_option :patreon, aliases: "-P", desc: "Add Patreon support.", type: :boolean, default: true
    def create name
      say
      info "Creating gem..."

      initialize_template_options name, options
      self.class.skeletons.each { |skeleton| skeleton.create self }

      info "Gem created."
      say
    end

    desc "-o, [open=OPEN]", "Open a gem in default editor."
    map %w(-o --open) => :open
    def open name
      process_gem name, "open"
    end

    desc "-r, [read=READ]", "Open a gem in default browser."
    map %w(-r --read) => :read
    def read name
      process_gem name, "read"
    end

    desc "-e, [--edit]", "Edit #{Gemsmith::Identity.label} settings in default editor."
    map %w(-e --edit) => :edit
    def edit
      `#{editor} #{@settings_file}`
    end

    desc "-v, [--version]", "Show #{Gemsmith::Identity.label} version."
    map %w(-v --version) => :version
    def version
      say Gemsmith::Identity.version_label
    end

    desc "-h, [--help=HELP]", "Show this message or get help for a command."
    map %w(-h --help) => :help
    def help task = nil
      say && super
    end
  end
end
