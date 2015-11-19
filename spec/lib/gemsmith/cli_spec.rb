require "spec_helper"

describe Gemsmith::CLI do
  let(:options) { [] }
  let(:command_line) { Array(command).concat options }
  let(:cli) { -> { described_class.start command_line } }

  shared_examples_for "a create command" do
    let(:gem_name) { "tester" }
    let(:gem_dir) { Pathname.new File.join(temp_dir, gem_name) }
    let :skeleton_files do
      files = Pathname.glob("#{gem_dir}/**/*", File::FNM_DOTMATCH).select(&:file?)
      files = files.map { |file| file.relative_path_from gem_dir }
      files = files.reject { |file| file.to_s =~ %r(^(\.git\/.+|\.tags)$) }
      files.map(&:to_s)
    end

    context "with no options", :temp_dir do
      let :options do
        [
          gem_name,
          "--no-cli",
          "--no-rails",
          "--no-security",
          "--no-pry",
          "--no-guard",
          "--no-rspec",
          "--no-rubocop",
          "--no-code-climate",
          "--no-gemnasium",
          "--no-travis",
          "--no-patreon"
        ]
      end

      it "creates basic skeleton" do
        Dir.chdir temp_dir do
          cli.call

          expect(skeleton_files).to contain_exactly(
            ".gitignore",
            ".ruby-version",
            "lib/tester/identity.rb",
            "lib/tester.rb",
            "CHANGELOG.md",
            "CODE_OF_CONDUCT.md",
            "CONTRIBUTING.md",
            "Gemfile",
            "LICENSE.md",
            "README.md",
            "Rakefile",
            "tester.gemspec"
          )
        end
      end
    end

    context "with all options", :temp_dir do
      let :options do
        [
          gem_name,
          "--cli",
          "--rails",
          "--security",
          "--pry",
          "--guard",
          "--rspec",
          "--rubocop",
          "--code-climate",
          "--gemnasium",
          "--travis",
          "--patreon"
        ]
      end

      it "creates full skeleton" do
        Dir.chdir temp_dir do
          cli.call

          expect(skeleton_files).to contain_exactly(
            ".gitignore",
            ".rubocop.yml",
            ".ruby-version",
            ".travis.yml",
            "bin/tester",
            "gemfiles/rails-4.2.x.gemfile",
            "lib/generators/tester/install/USAGE",
            "lib/generators/tester/install/install_generator.rb",
            "lib/generators/tester/upgrade/USAGE",
            "lib/generators/tester/upgrade/upgrade_generator.rb",
            "lib/tester/tasks/rspec.rake",
            "lib/tester/tasks/rubocop.rake",
            "lib/tester/cli.rb",
            "lib/tester/engine.rb",
            "lib/tester/identity.rb",
            "lib/tester.rb",
            "spec/lib/tester/tester_spec.rb",
            "spec/support/extensions/pry.rb",
            "spec/support/kit/default_config.rb",
            "spec/support/kit/stderr.rb",
            "spec/support/kit/stdout.rb",
            "spec/support/kit/temp_dir.rb",
            "spec/spec_helper.rb",
            "CHANGELOG.md",
            "CODE_OF_CONDUCT.md",
            "CONTRIBUTING.md",
            "Gemfile",
            "Guardfile",
            "LICENSE.md",
            "Rakefile",
            "README.md",
            "tester.gemspec"
          )
        end
      end
    end
  end

  shared_examples_for "a version command" do
    it "prints version" do
      expect(&cli).to output(/Gemsmith\s#{Gemsmith::Identity.version}\n/).to_stdout
    end
  end

  shared_examples_for "a help command" do
    it "prints usage" do
      expect(&cli).to output(/Gemsmith\s#{Gemsmith::Identity.version}\scommands:\n/).to_stdout
    end
  end

  describe ".source_root" do
    it "answers source root" do
      expect(described_class.source_root).to include("gemsmith/lib/gemsmith/templates")
    end
  end

  describe ".skeletons" do
    it "answers gem skeletons" do
      expect(described_class.skeletons).to contain_exactly(Gemsmith::Skeletons::GemSkeleton,
                                                           Gemsmith::Skeletons::DocumentationSkeleton,
                                                           Gemsmith::Skeletons::RakeSkeleton,
                                                           Gemsmith::Skeletons::CLISkeleton,
                                                           Gemsmith::Skeletons::RubySkeleton,
                                                           Gemsmith::Skeletons::RailsSkeleton,
                                                           Gemsmith::Skeletons::RspecSkeleton,
                                                           Gemsmith::Skeletons::RubocopSkeleton,
                                                           Gemsmith::Skeletons::GuardSkeleton,
                                                           Gemsmith::Skeletons::PrySkeleton,
                                                           Gemsmith::Skeletons::TravisSkeleton,
                                                           Gemsmith::Skeletons::BundlerSkeleton,
                                                           Gemsmith::Skeletons::GitSkeleton)
    end
  end

  describe "--create" do
    let(:command) { "--create" }
    it_behaves_like "a create command"
  end

  describe "-c" do
    let(:command) { "-c" }
    it "behaves like a create command"
  end

  describe "--open" do
    let(:command) { "--open" }
    it "behaves like an open command"
  end

  describe "-o" do
    let(:command) { "-o" }
    it "behaves like an open command"
  end

  describe "--read" do
    let(:command) { "--read" }
    it "behaves like a read command"
  end

  describe "-r" do
    let(:command) { "-r" }
    it "behaves like a read command"
  end

  describe "--edit" do
    let(:command) { "--edit" }
    it "behaves like an edit command"
  end

  describe "-e" do
    let(:command) { "-e" }
    it "behaves like an edit command"
  end

  describe "--version" do
    let(:command) { "--version" }
    it_behaves_like "a version command"
  end

  describe "-v" do
    let(:command) { "-v" }
    it_behaves_like "a version command"
  end

  describe "--help" do
    let(:command) { "--help" }
    it_behaves_like "a help command"
  end

  describe "-h" do
    let(:command) { "-h" }
    it_behaves_like "a help command"
  end

  context "with no command" do
    let(:command) { nil }
    it_behaves_like "a help command"
  end
end
