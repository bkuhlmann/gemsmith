require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"
require "gemsmith/cli_options"
require "gemsmith/cli_helpers"
require "gemsmith/skeletons/base_skeleton"
require "gemsmith/skeletons/cli_skeleton"
require "gemsmith/skeletons/default_skeleton"
require "gemsmith/skeletons/documentation_skeleton"
require "gemsmith/skeletons/git_skeleton"
require "gemsmith/skeletons/guard_skeleton"
require "gemsmith/skeletons/rails_skeleton"
require "gemsmith/skeletons/rspec_skeleton"
require "gemsmith/skeletons/travis_skeleton"

module Gemsmith
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions
    include CLIOptions
    include CLIHelpers

    package_name Gemsmith::Identity.label

    # Overwrites the Thor template source root.
    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "templates")
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
    method_option :code_climate, aliases: "-c", desc: "Add Code Climate support.", type: :boolean, default: true
    method_option :gemnasium, aliases: "-G", desc: "Add Gemnasium support.", type: :boolean, default: true
    method_option :travis, aliases: "-t", desc: "Add Travis CI support.", type: :boolean, default: true
    def create name
      say
      info "Creating gem..."

      initialize_template_options name, options
      Skeletons::DefaultSkeleton.run self
      Skeletons::DocumentationSkeleton.run self
      Skeletons::CLISkeleton.run(self) if template_options[:bin]
      Skeletons::RailsSkeleton.run(self) if template_options[:rails]
      Skeletons::RspecSkeleton.run(self) if template_options[:rspec]
      Skeletons::GuardSkeleton.run(self) if template_options[:guard]
      Skeletons::TravisSkeleton.run(self) if template_options[:travis]
      Skeletons::GitSkeleton.run self

      info "Gem created."
      say
    end

    desc "-o, [open=OPEN]", "Open gem in default editor (assumes $EDITOR environment variable)."
    map %w(-o --open) => :open
    def open name
      process_gem name, "open"
    end

    desc "-r, [read=READ]", "Open gem in default browser."
    map %w(-r --read) => :read
    def read name
      process_gem name, "read"
    end

    desc "-e, [edit]", "Edit gem in default editor (assumes $EDITOR environment variable)."
    map %w(-e --edit) => :edit
    def edit
      `#{editor} #{@settings_file}`
    end

    desc "-v, [--version]", "Show version."
    map %w(-v --version) => :version
    def version
      say Gemsmith::Identity.label_version
    end

    desc "-h, [--help=HELP]", "Show this message or get help for a command."
    map %w(-h --help) => :help
    def help task = nil
      say and super
    end
  end
end
