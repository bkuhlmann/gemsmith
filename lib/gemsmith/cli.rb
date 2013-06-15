require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"
require "gemsmith/cli_helpers"
require "gemsmith/skeletons/base_skeleton"
require "gemsmith/skeletons/default_skeleton"
require "gemsmith/skeletons/documentation_skeleton"
require "gemsmith/skeletons/cli_skeleton"
require "gemsmith/skeletons/rails_skeleton"
require "gemsmith/skeletons/rspec_skeleton"
require "gemsmith/skeletons/travis_skeleton"
require "gemsmith/skeletons/git_skeleton"

module Gemsmith
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions
    include CLIHelpers

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

    desc "-c, [create=GEM_NAME]", "Create new gem."
    map "-c" => :create
    method_option :bin, aliases: "-b", desc: "Add binary support.", type: :boolean, default: false
    method_option :rails, aliases: "-r", desc: "Add Rails support.", type: :boolean, default: false
    method_option :pry, aliases: "-p", desc: "Add Pry support.", type: :boolean, default: true
    method_option :guard, aliases: "-g", desc: "Add Guard support.", type: :boolean, default: true
    method_option :rspec, aliases: "-s", desc: "Add RSpec support.", type: :boolean, default: true
    method_option :travis, aliases: "-t", desc: "Add Travis CI support.", type: :boolean, default: true
    method_option :code_climate, aliases: "-c", desc: "Add Code Climate support.", type: :boolean, default: true
    def create name
      say
      info "Creating gem..."

      build_template_options name, @settings, options

      Skeletons::DefaultSkeleton.run self
      Skeletons::DocumentationSkeleton.run self
      Skeletons::CLISkeleton.run(self) if template_options[:bin]
      Skeletons::RailsSkeleton.run(self) if template_options[:rails]
      Skeletons::RspecSkeleton.run(self) if template_options[:rspec]
      Skeletons::TravisSkeleton.run(self) if template_options[:travis]
      Skeletons::GitSkeleton.run self

      info "Gem created."
      say
    end

    desc "-o, [open=NAME]", "Opens gem in default editor (assumes $EDITOR environment variable)."
    map "-o" => :open
    def open name
      gems = Gem::Specification.find_all_by_name name
      case
        when gems.size == 1
          `$EDITOR #{gems.first.full_gem_path}`
        when gems.size > 1
          print_gem_versions gems
          open_gem gems
        else
          say "Unable to find gem: #{name}"
      end
    end

    desc "-e, [edit]", "Edit gem settings in default editor (assumes $EDITOR environment variable)."
    map "-e" => :edit
    def edit
      `$EDITOR #{@settings_file}`
    end

    desc "-v, [version]", "Show version."
    map "-v" => :version
    def version
      say "Gemsmith " + VERSION
    end

    desc "-h, [help]", "Show this message."
    def help task = nil
      say and super
    end
  end
end
