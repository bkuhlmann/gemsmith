# 12.2.0 (2018-07-01)

- Fixed Rubocop Style/UnneededCondition issue.
- Updated Semantic Versioning links to be HTTPS.
- Updated to Reek 5.0.
- Updated to Rubocop 0.57.0.
- Updated to Versionaire 6.0.0.

# 12.1.0 (2018-05-01)

- Added Runcom examples for project specific usage.
- Updated README screencast.
- Updated project changes to use semantic versions.
- Updated to Milestoner 8.2.0.
- Updated to Pragmater 5.2.0.
- Updated to Refinements 5.2.0.
- Updated to Runcom 3.1.0.

# 12.0.0 (2018-04-01)

- Added gemspec metadata for source, changes, and issue tracker URLs.
- Updated to Git Cop 2.1.0.
- Updated to Milestoner 8.0.0.
- Updated to Refinements 5.1.0.
- Updated to Ruby 2.5.1.
- Updated to Runcom 3.0.0.
- Removed Circle CI Bundler cache.
- Removed `rake doc` task (use `rake toc` instead).
- Removed deprecated `--generate --rails` option.
- Refactored Rails generator as Engine generator.
- Refactored base generator lib root for gem.
- Refactored temp dir shared context as a pathname.

# 11.3.0 (2018-03-10)

- Added `--generate --engine` option.
- Added `--generate --rails` deprecation warning.
- Updated gem dependencies.
- Updated to Code Quality 2.1.0.
- Updated to Rubocop 0.53.0.
- Refactored generate template method.

# 11.2.0 (2018-03-04)

- Fixed Rubocop Style/MissingElse issues.
- Fixed gemspec issues with missing gem signing key/certificate.
- Updated to Code Quality 2.0.0.
- Removed Gemnasium support.
- Removed secure install documentation from README template.

# 11.1.0 (2018-01-27)

- Fixed spec helper template.
- Added Reek configuration file.
- Updated README license information.
- Updated initial Git commit message for gem generation.
- Updated to Circle CI 2.0.0 configuration.

# 11.0.1 (2018-01-01)

- Fixed gemspec template dependencies.

# 11.0.0 (2018-01-01)

- Updated Bundler Audit option to be enabled by default.
- Updated Code Climate badges.
- Updated Code Climate configuration to Version 2.0.0.
- Updated GitHub option to be enabled by default for gem generation.
- Updated gem generation security option to be false by default.
- Updated to Apache 2.0 license.
- Updated to Pragmater 5.0.0.
- Updated to Rubocop 0.52.0.
- Updated to Ruby 2.4.3.
- Updated to Ruby 2.5.0.
- Removed Patreon support.
- Removed SCSS Lint support.
- Removed documentation for secure installs.
- Removed empty gemspec fixture.
- Refactored CLI spec to use Git file list.
- Refactored code to use Ruby 2.5.0 `Array#append` syntax.
- Refactored gem module formater to only strip prefixed newlines.

# 10.4.2 (2017-11-19)

- Updated to Git Cop 1.7.0.
- Updated to Rake 12.3.0.

# 10.4.1 (2017-10-29)

- Updated to Rubocop 0.51.0.

# 10.4.0 (2017-09-23)

- Added Bundler Audit support.
- Updated CLI `--generate` options to be alpha-sorted.
- Updated to Code Quality 1.3.0.
- Updated to Rubocop 0.50.0.
- Updated to Ruby 2.4.2.
- Removed Pry State gem.

# 10.3.0 (2017-08-20)

- Fixed Rubocop gem dependency.
- Added dynamic formatting of RSpec output.
- Updated to Code Quality 1.2.0.
- Updated to Git Cop 1.3.0.
- Updated to Runcom 1.3.0.

# 10.2.0 (2017-07-16)

- Added Gemsmith version to gem skeleton commit message.
- Updated gem dependencies.

# 10.1.0 (2017-06-28)

- Updated CONTRIBUTING documentation.
- Updated GitHub templates.
- Updated gem dependencies.

# 10.0.0 (2017-06-18)

- Fixed Reek DuplicateMethodCall issues.
- Fixed Reek UtilityFunction issues.
- Fixed gem label generation.
- Fixed version/help command specs.
- Added Circle CI support.
- Added Git Cop support.
- Added gemspec package path.
- Updated README headers.
- Updated gem dependencies.
- Updated to Runcom 1.1.0.
- Removed Climate Control from CLI specs.
- Removed Thor+ support.
- Removed Travis CI support.
- Removed local Travis CI configuration.
- Refactored CLI spec setup.
- Refactored Reek issues.
- Refactored pragma generator to use runner.

# 9.6.0 (2017-05-27)

- Fixed Reek InstanceVariableAssumption issues.
- Fixed alignment with spec return statements.
- Added existing gem setup documentation.
- Updated to Bundler 1.15.
- Updated to Code Quality 1.1.0.
- Updated to Rubocop 0.49.0.

# 9.5.0 (2017-05-07)

- Added Rails 5.1.0 support.
- Updated Code Climate configuration.
- Updated Rubocop configuration.
- Updated gem dependencies.

# 9.4.0 (2017-04-23)

- Fixed Open SSL namespace issues.
- Fixed issue with gem credentials password prompt not being masked.

# 9.3.0 (2017-04-01)

- Fixed OpenSSL requirement.
- Fixed aggressive pragma auto-correction for gem generation.
- Fixed gem credentials requirement order.
- Fixed install of gem dependencies.
- Updated Guardfile to always run RSpec with documentation format.
- Updated to Ruby 2.4.1.
- Refactored gem root to base generator.

# 9.2.0 (2017-02-11)

- Fixed Rubocop Style/CollectionMethods issues.
- Fixed Rubocop Style/FirstMethodArgumentLineBreak issues.
- Fixed Rubocop Style/SymbolArray issues.
- Updated README semantic versioning order.
- Updated RSpec configuration to output documentation when running.
- Updated gemspec template to latest Thor+ and Runcom versions.
- Updated to Code Quality 0.3.0.

# 9.1.0 (2017-02-05)

- Fixed Travis CI configuration to not update gems.
- Added `tmp` directory to Git ignore template.
- Added code quality Rake task.
- Updated RSpec spec helper to enable color output.
- Updated Rubocop to import from global configuration.
- Updated contributing documentation.
- Removed Code Climate code comment checks.
- Removed `.bundle` directory from `.gitignore`.

# 9.0.0 (2017-01-22)

- Fixed Rails Engine JavaScript and stylesheet templates.
- Fixed aggressive Rubocop auto-correction for gem generation.
- Fixed attempting to generate a gem with CLI and Rails Engine options.
- Added Bundler gem dependency.
- Added Rails-specific folders to gemspec when generating Rails Engines.
- Added required Ruby version to gemspec generation.
- Updated Rubocop Metrics/LineLength to 100 characters.
- Updated Rubocop Metrics/ParameterLists max to three.
- Updated Travis CI configuration to use latest RubyGems version.
- Updated gemspec to require Ruby 2.4.0 or higher.
- Updated to Rubocop 0.47.
- Updated to Ruby 2.4.0.
- Removed Rubocop Style/Documentation check.
- Refactored gem path access to base generator.

# 8.2.0 (2016-12-18)

- Fixed Rakefile support for RSpec, Reek, Rubocop, and SCSS Lint.
- Added `Gemfile.lock` to `.gitignore`.
- Updated Travis CI configuration to use defaults.
- Updated to Rake 12.x.x.
- Updated to Rubocop 0.46.x.
- Updated to Ruby 2.3.2.
- Updated to Ruby 2.3.3.
- Refactored gem name to base generator.

# 8.1.0 (2016-11-13)

- Fixed Rake Publisher not loading Gemsmith configuration properly.
- Updated CLI template to not use gem namespace for identity.
- Updated gem library to require CLI if enabled.
- Refactored CLI/Template helpers.
- Refactored source requirements.
- Refactored symbolization of Thor option keys.

# 8.0.0 (2016-11-12)

- Fixed Bash script header to dynamically load correct environment.
- Fixed CLI class method evaluation.
- Fixed CLI helper stack dump when dealing with non-symantic versions.
- Fixed CLI spec to fake Rails engine file generation.
- Fixed RSpec helpers so that Rails engine is loaded correctly.
- Fixed Rails skeleton generation so test unit is skipped.
- Fixed Rakefile to safely load Gemsmith tasks.
- Fixed Rubocop Style/NumericLiteralPrefix issues.
- Fixed Ruby pragma.
- Added CLI spec to CLI skeleton generation.
- Added CLI template helper.
- Added Code Climate engine support.
- Added GitHub convenience methods for obtaining user and URL info.
- Added Pragmater gem.
- Added Rails skeleton file removal support.
- Added Rails skeleton source commenting.
- Added Reek support.
- Added Rubocop skeleton autofix support.
- Added SCSS Lint support.
- Added `--config` command.
- Added default configuration for publishing signed gems.
- Added frozen string literal pragma.
- Added gem build support.
- Added gem configuration to rake publisher.
- Added gem inspector.
- Added gem install support.
- Added gem path configuration support.
- Added gem path to CLI helper.
- Added gem specification name support.
- Added gem specification path.
- Added lib gem root path support to base skeleton.
- Added module formatter (template helper).
- Added namespace formatter to CLI helper module.
- Added pragma skeleton.
- Updated CLI command option documentation.
- Updated Code Climate configuration to default to false.
- Updated Code Climate configuration to use CLI options.
- Updated Gemnasium configuration to default to false.
- Updated Patreon configuration to default to false.
- Updated README to mention "Ruby" instead of "MRI".
- Updated README versioning documentation.
- Updated README word wrapping column limit.
- Updated RSpec temp directory to use Bundler root path.
- Updated Travis CI configuration to default to false.
- Updated `--generate` command to use configuration defaults.
- Updated `rake publish` task description to included tag signing.
- Updated gem skeletons and temlates to use gem path.
- Updated gemspec with conservative versions.
- Updated templates to render indented namespaces properly.
- Updated templates to use gem path.
- Updated to Bundler 1.13.
- Updated to Code Climate Test Reporter 1.0.0.
- Updated to Rails 5.0.0.
- Updated to Refinements 3.0.0.
- Updated to Rubocop 0.44.
- Updated to Versionaire 2.0.0.
- Removed "gem.home_url" configuration key (use "gem.url" instead).
- Removed Bundler Rake tasks.
- Removed CHANGELOG.md (use CHANGES.md instead).
- Removed CLI defaults (using configuration instead).
- Removed Gemsmith::Aids::Spec object.
- Removed Rake console task.
- Removed TODO comments from Rails generators.
- Removed `--create` option (use `--generate` instead).
- Removed `--edit` command.
- Removed `--generate` command option aliases.
- Removed `:create` configuration key (use `:generate` instead).
- Removed `Gemsmith::Configuration`.
- Removed `rake release` task.
- Removed duplicate CLI helper methods.
- Removed frozen string literal pragma from templates
- Removed gem class initialization from configuration.
- Removed gemspec description.
- Removed gemspec development dependency for Bundler.
- Removed gemspec private and public key support.
- Removed generation of default gem RSpec spec.
- Removed rb-fsevent development dependency from gemspec.
- Removed snakecase formatting from gem name.
- Removed terminal notifier gems from gemspec.
- Removed unused "vendor" folder from gemspec.
- Removed unused gem specification inspect methods.
- Refactored CLI configuration to inherit from Runcom configuration.
- Refactored CLI to use gem inspector.
- Refactored RSpec spec helper configuration.
- Refactored Rake tasks so that dependencies are injected.
- Refactored `Gemsmith::Aids::GemSpec` as `Gemsmith::Gem::Specification`.
- Refactored `Gemsmith::Aids::Git` as `Gemsmith::Git`.
- Refactored `Gemsmith::Gem::Specification` to use Versionaire version.
- Refactored `Gemsmith::Rake::Build` as `Gemsmith::Rake::Builder`.
- Refactored `Gemsmith::Rake::Release` as `Gemsmith::Rake::Publisher`.
- Refactored gemspec aid to use guard clause when validating.
- Refactored gemspec to use default security keys.
- Refactored generators to use `#run` instead of `#create`.
- Refactored skeletons as generators.

# 7.7.0 (2016-05-15)

- Fixed Rubocop array style issues in gem templates.
- Fixed gem name/class snakecase/camelcase issues.
- Fixed issues with opening of invalid gems in default editor.
- Added Versionaire gem.
- Added `Gemsmith::Aids::Spec` deprecation documentation.
- Added gem requirement errors.
- Added gem requirement support.
- Updated gemspec template to default to blank summary and description.
- Updated to Refinements 2.2.1.
- Updated to Rubocop 0.40.0.
- Updated to Ruby 2.3.1.
- Removed unused Pry gems.
- Refactored gem specification to use gem requirement.

# 7.6.0 (2016-04-24)

- Fixed Rubocop issues with CLI array options.
- Added Refinements gem.
- Added string refinements to CLI.
- Updated Rubocop PercentLiteralDelimiters and AndOr styles.
- Updated to Milestoner 3.0.0.
- Updated to Tocer 2.2.0.
- Removed gem aid.
- Removed gem label from CLI edit and version descriptions.

# 7.5.0 (2016-04-03)

- Fixed README gem credential documentation typos.
- Added --generate (-g) command.
- Added bond, wirb, hirb, and awesome_print development dependencies.
- Added default GitHub key configuration to README.
- Updated GitHub issue and pull request skeleton templates.

# 7.4.0 (2016-03-13)

- Added RubyGems authenticator.
- Added a basic authenticator.
- Added default editor to CI configuration.
- Added error checking when pushing gem to remote server.
- Added gem credentials support.
- Added gem specific error classes.
- Added gem specification wrapper.
- Added valid, default, metadata to gemspec fixtures.
- Refactored CLI to use gem spec wrapper.
- Refactored Rake release object to use gem credentials.
- Refactored Rake release to define path to current gemspec.
- Refactored Rake release to use gem spec wrapper.
- Refactored Rake tasks to use gem spec wrapper.
- Refactored gem specification as an aid.
- Refactored gem specification error class.

# 7.3.0 (2016-02-29)

- Added README Screencasts section.
- Added README documentation for private gem servers.
- Added custom gem credentials and gemspec metadata support.
- Updated README secure gem install documentation.
- Updated Rake publish task to use new gem push capabilities.
- Updated Rake release to publish signed and unsigned Git tags.
- Updated Rake release to tag and push gem to remote server.
- Updated `rake release` to use custom release process.

# 7.2.0 (2016-02-20)

- Fixed Rubocop Rails configuration.
- Fixed contributing guideline links.
- Fixed gem skeleton binary file permissions to be executable.
- Fixed missing versions from gemspec template.
- Added Bundler dependency to gemspec.
- Added GitHub issue and pull request templates.
- Added GitHub support to gem skeleton creation.
- Added RSpec gemspec version requirement.
- Added Rubocop Style/SignalException cop style.
- Added Rubocop gemspec version requirement.
- Added shell setup script to gem skeleton creation.
- Updated to Code of Conduct, Version 1.4.0.

# 7.1.0 (2016-01-20)

- Fixed README template documentation for gem certificate.
- Fixed gem secure install issues.
- Removed frozen string literal from Rake files.

# 7.0.0 (2016-01-17)

- Fixed spec formatting (minor).
- Added IRB console Rake task support.
- Updated Git Signing Key and Promotion README documentation.
- Updated to Ruby 2.3.0.
- Removed RSpec default monkey patching behavior.
- Removed Ruby 2.1.x and 2.2.x support.
- Refactored templates to use `Hash#dig`.

# 6.2.0 (2015-12-02)

- Fixed CLI long form command usage documentation.
- Added Milestoner and Tocer gems to README feature list.
- Updated README Rake documentation.
- Updated README template so HTTPS links are used.
- Removed invalid gem promotion links from README.
- Update README URLs based on HTTP redirects.

# 6.1.0 (2015-11-27)

- Fixed bug where Git tags were not being pushed to remote.
- Added CLI info message when opening a gem.
- Added CLI info message when reading a gem.
- Added asciinema screencast to README features.

# 6.0.0 (2015-11-25)

- Fixed README template so Gemfile setup is available for non-CLI skeletons.
- Fixed README test command instructions.
- Fixed Rails skeleton to use Rails version for gemfiles.
- Fixed bug with Rake not added as a gemspec dev dependency.
- Added CLI specs for all commands.
- Added Git option to configuration initialization.
- Added Patreon (i.e. --patreon) support to gem creation.
- Added Patreon badge to README.
- Added Rails install prompt when creating Rails Engines.
- Added Ruby Green News to README.
- Added Ruby version detection.
- Added [Tocer](https://github.com/bkuhlmann/tocer) support.
- Added build validation to Rake build and publish tasks.
- Added dynamic generation of GitHub gem URL.
- Added gem configuration support.
- Added gem name and class aid.
- Added gem spec aid.
- Added info message to CLI edit command.
- Updated .travis.yml skeleton to use latest Ruby version.
- Updated Code Climate to run when CI ENV is set.
- Updated to Code of Conduct 1.3.0.
- Updated build validation to not fail with an exception.
- Updated gem skeleton templates to use configuration settings.
- Updated to Rails 4.2 gemfiles.
- Removed "clean" Rake task prerequisite from "publish" task.
- Removed "readme:toc" Rake task (replaced with "doc").
- Removed CLI options module.
- Removed DocToc support.
- Removed Rubocop TODO list.
- Removed `Gemsmith::Kit` (use `Gemsmith::Aids::Git` instead).
- Removed `Gemsmith::Rake::Build#clean!` (replaced with `#clean`).
- Removed unnecessary exclusions from .gitignore.
- Refactored RSpec Pry support as an extension.
- Refactored Rake tasks to standard location.

# 5.6.0 (2015-09-27)

- Fixed RSpec example status persistence file path.
- Fixed RSpec temp dir cleanup.
- Fixed gem identity module description.
- Added Milestoner support.

# 5.5.0 (2015-09-16)

- Updated --edit option to include gem name in description.
- Updated Rubocop Style/PercentLiteralDelimiters setting.
- Updated Rubocop config to enable Rails cops when Rails is enabled.
- Updated gem description.
- Added --edit option to binary skeleton.
- Added gem configuration file name to identity.
- Added gem label to CLI version description.
- Removed "# Initialize" comment from CLI skeleton.
- Removed Aruba gem from binary skeletons.
- Removed Rubocop Style/NumericLiterals support.
- Removed Ruby on Rails dependency.
- Removed email notifications for Travis CI skeletons.

# 5.4.0 (2015-08-30)

- Fixed Rails RSpec spec helper configuration.
- Removed Rails .gitignore file generation.
- Removed Rails application helper generation.
- Removed Rails version file generation.
- Removed Ruby version requirement from gemspec skeleton.
- Updated to Ruby 2.2.3.
- Updated to Rails 4.2.4.
- Updated Rakefile to use Gemsmith rake tasks.
- Added Rubocop support.
- Added RSpec Rake tasks.
- Added Gemsmith development requirement to gem skeleton gemspec.
- Added supplemental rake tasks for building and publishing gems:
    - rake clean                 # Clean gem artifacts
    - rake publish               # Build, tag v5.4.0 (signed), and push gemsmith-5.4.0.gem to RubyGems
    - rake readme:toc            # Update README Table of Contents
    - rake rubocop               # Run RuboCop
    - rake rubocop:auto_correct  # Auto-correct RuboCop offenses
    - rake spec                  # Run RSpec code examples

# 5.3.0 (2015-08-02)

- Fixed bug where --no-security option would add security text to README.md.
- Updated to Code of Conduct 1.2.0.
- Added CODE OF CONDUCT to template install.
- Added [pry-state](https://github.com/SudhagarS/pry-state) development support.
- Added bundler skeleton support.
- Added project name to README.
- Added table of contents to README.

# 5.2.0 (2015-07-19)

- Fixed bug with class name not being generated for gemspec name properly.
- Fixed install of missing identity template.
- Fixed invalid install of RSpec garbage collection template.

# 5.1.0 (2015-07-05)

- Removed JRuby support (no longer officially supported).
- Fixed secure gem installs (new cert has 10 year lifespan).
- Updated to Ruby 2.2.2.
- Added CLI process title support.
- Added code of conduct documentation.

# 5.0.0 (2015-01-01)

- Removed Ruby 2.0.0 support.
- Removed Rubinius support.
- Removed auto-generated MIT-LICENSE and REAMDE.rdoc from rails engine templates.
- Fixed bug where engine.rb was not required for rails engine.
- Updated to Thor+ 2.x.x.
- Updated spec helper to comment custom config until needed.
- Updated Rails option to default to version 4.2 instead of 4.1.
- Updated gemspec to use RUBY_GEM_SECURITY env var for gem certs.
- Added security option to gem creation. Default: true.
- Added Ruby 2.2.0 support.
- Added Rails 4.2.x support.

# 4.3.0 (2014-10-22)

- Updated to Thor+ 1.7.x.
- Updated gemspec author email address.

# 4.2.0 (2014-09-21)

- Updated to Ruby 2.1.3.
- Updated Code Climate to run only if environment variable is present.
- Added the Guard Terminal Notifier gem.
- Refactored RSpec setup and support files.

# 4.1.0 (2014-08-10)

- Updated --rails flag of --create option to support full Rails Engine template creation.
- Updated RSpec config to verify partial doubles.
- Updated gemspec to add security keys unless in a CI environment.

# 4.0.0 (2014-08-03)

- Removed Coveralls support.
- Removed Ruby version patch support.
- Removed Rails controller, view, and model templates.
- Removed gem namespace setup from gem main library file.
- Fixed Rails version in .travis.yml template.
- Updated the Travis CI gemfile template to Rails 4.1.x.
- Updated to Rubinius 2.2.10.
- Updated Ruby version default to 2.1.2.
- Updated Rails version default to 4.1.
- Updated email to be an array in the gemspec.
- Added test randomization to spec helper.
- Added Code Climate test coverage support.
- Added authors array to gemspec.
- Added Guardfile generation for the --guard option.

# 3.2.0 (2014-07-06)

- Added Code Climate test coverage support.
- Updated to Ruby 2.1.2.
- Updated gem-public.pem for gem install certificate chain.

# 3.1.0 (2014-04-16)

- Updated to Thor 0.19.x.
- Updated to Thor+ 1.5.x.
- Updated RSpec helper to disable GC for all specs in order to improve performance.

# 3.0.0 (2014-03-25)

- Removed the pry-vterm_aliases gem.
- Updated to MRI 2.1.1.
- Updated to Rubinius 2.x.x support.
- Updated to Rails 4.0.
- Updated README with --trust-policy for secure install of gem.
- Added Gemnasium badge support.
- Added Coveralls badge support.
- Added security support (including customization) of gem signing key and cert chain.
- Added JRuby and Rubinius support to gem skeleton generation.

# 2.4.0 (2014-02-15)

- Added JRuby and Rubinius VM support.

# 2.3.0 (2014-01-26)

- Added gem certificate information to the README security section.
- Updated new skeleton Git commit message.
- Updated gem-public.pem to default to ~/.ssh in gemspec template.
- Updated gem option descriptions.
- Updated gemspec homepage URL to use GitHub project URL.

# 2.2.0 (2013-12-28)

- Fixed long-form commands to use "--" prefix. Example: --example.
- Fixed Ruby Gem certificate requirements for package building.
- Fixed RSpec deprecation warnings for treating metadata symbol keys as true values.
- Removed UTF-8 encoding definitions - This is the default in Ruby 2.x.x.
- Removed .ruby-version from .gitignore.
- Removed Linux Guard notification support.
- Updated to Ruby 2.1.0.
- Updated the ignoring of signing a gem when building in a Travis CI environment.
- Updated public gem certificate to be referenced from a central server.
- Added a Versioning section to the README as defined here: https://semver.org.
- Added public cert for secure install of gem.
- Added Pry plugin requirements to RSpec spec helper.

# 2.1.0 (2013-06-15)

- Removed Rails 3.0.x and 3.1.x template support.
- Removed the CHANGELOG documentation from gem install.
- Added the ability to read a gem (opens gem homepage in default browser).
- Added the ability to treat symbols as true values by default when running RSpec specs.
- Added .ruby-version support including Ruby patch support (can be specified as a config option too).
- Added documentation for documenting and promiting a gem to README.
- Added 'How to Spread the Word About Your Code' link to README. Thanks Eric.
- Added a link to Semantic Versioning to the README.
- Added 'Gem Activiation and You, Parts I and II' to the README.
- Switched to using Markdown instead of Rdoc for documentation.
- Switched from pry-nav to the pry-debugger gem.
- Updated gemspec to Thor 0.18 and higher.
- Added pry-rescue support.
- Cleaned up requirement path syntax.
- Significantly refactored the code as follows into cli helpers/options modules, feature skeletons, etc.
- Removed extraneous gem source documentation.
- Refactored all templates to use .tt suffixes.
- Switched to using relative source tree structures for templates so that destination reflects source.
- Refactored the code for opening and reading a gem.

# 2.0.0 (2013-03-17)

- Added Railtie best practices to README.
- Added Guard support.
- Converted/detailed the CONTRIBUTING guidelines per GitHub requirements.
- Updated the contribution details in the README template to point to the CONTRIBUTING template.
- Added spec focus capability.
- Added Gem Badge support.
- Added Code Climate support.
- Added Campfire notification support.
- Switched from HTTP to HTTPS when sourcing from RubyGems.
- Added Pry support.
- Cleaned up Guard gem dependency requirements.
- Added Guard support to gem generation.
- Upgraded to Ruby 2.0.0.

# 1.5.0 (2012-05-19)

- Added auto-linking to GitHub Issues via README template.
- Relaxed Rails gem settings to 3.x.x.
- Switched gem dependency to Thor 0.x.x range.
- Switched gem dependency to Thor+ 0.x.x range.

# 1.4.0 (2012-01-29)

- Added Travis CI templates for Rails build matrix that can support multiple version tests.
- Added vendor files to gemspec template so they are included when building a new gem (especially Rails related).
- Moved library requirements within the Rails conditional check so that requirements are only loaded if Rails is detected.
- Modified the RSpec development dependency so that if Rails is detected, the rspec-rails gem is included instead.
- Changed the Rails default version to 3.2.0.

# 1.3.0 (2012-01-14)

- Specified Thor+ 0.2.x version dependency.
- Added Travis CI support.
- Added Travis CI template support (can be disable via your settings.yml or during new gem creation).
- Added the spec/tmp directory to the gitignore template.
- Added Gemsmith::Kit class with a supplementary utility method for obtaining .gitconfig values.
- Added github user support - Defaults to github config file or settings.yml.
- Updated RSpec format to better represent class and instance methods.
- Removed the -w option from gem binary and the binary template.
- No longer shell out to Git when referencing the gem/template files in gemspecs - This increases Rails boot performance.
- Switched Gemfile and Gemfile.tmp reference from "http://rubygems.org" to :rubygems.
- Moved documentation files to the extra_rdoc_files option for gem specifications
- Removed the packaging of test files.

# 1.2.0 (2012-01-02)

- Updated README and README template with new layout for test instructions.
- Upgraded to Thor+ 0.2.0 and removed the settings_file, settings, and load_settings methods.
- Added Why You Should Use a BSD license to the README Best Practices section.
- Added the Best Practices While Cutting Gems to the Best Practices section of the README.
- Added the ruby warning and encoding option formats to the binary template.
- Removed the do block from RSpec template so that initial tests show pending instead of successful results.

# 1.1.0 (2011-11-20)

- Fixed bug where args, options, and config were not being passed to super for CLI initialize for gem and gem template generation.
- Updated gemspec settings and removed rubygem requirements from spec helper.
- Defaulted RSpec output to documentation format for project and template generation.
- Added Ruby on Rails Gem Packaging to Best Practices section of README.
- Added the -o option for opening a gem in the default editor.
- Added RSpec documentation to README and README template.
- Added Tests, Contributions, and Credits section to README and README template.

# 1.0.0 (2011-10-29)

- Upgraded to Ruby 1.9 and added Ruby 1.9 requirements.
- Upgraded Rails defaults to 3.1.x.
- Renamed ActionController and ActiveRecord class methods templates to be acts_as_- instead of is_*_enhanced.
- Changed gem specifications to use singular form of author and email.
- Added a gem_url setting (which is different from the author_url but does default to it).
- Added a Company header to the README template.
- Added the MIT license to the gemspec template.
- Added the post_install_message option for adding custom messages to gem install output.
- Simplified all TODO messages in the templates.
- Added Thor+ gem requirement.
- Removed the Utilities module and replaced all info and error messages with Thor+ actions.
- Added requirements and includes for the Thor+ gem when generating binary-enabled gem skeletons.
- Added the YAML requirement to the CLI template.

# 0.5.0 (2011-08-27)

- Fixed bug with wrong definition of ActionView instance method include for main gem template.
- Changed the ActionView template behavior so that instance methods are auto-included.
- Renamed the execute methods for the install and upgrade generators to install and upgrade respectively.
- Added Rails version options. Default: 3.0.0.
- Added Ruby version option. Default: 1.9.2.
- Made the module namespace optional when building gems specifically for Rails.
- Relabeled the TODO helper text for all templates.

# 0.4.0 (2011-07-31)

- Fixed bug with options not being supplied as second argument to write_inheritable_attribute for ActionController and ActiveRecord class method templates.
- Changed the -R option to -r for Rails and added the -s option for RSpec.
- Trimmed ERB whitespace from templates where apt.
- Cleaned up the source_root code for both the install and upgrade generator templates.
- Renamed the copy_files method to the execute method for both the install and upgrade generator templates.
- Moved desc method next to execution method for both the install and upgrade generator templates.
- Removed the banners from the install and upgrade generator templates since this is auto-generated by Thor.

# 0.3.0 (2011-07-10)

- Added Best Practices section to the README.
- Added the -e (edit) option for editing gem settings in default editor.
- Added Thor utilities for info and error messaging.
- Removed the classify and underscore methods since their equivalents are found in the Thor::Util class.
- Removed the print_version method.
- Added Rails generator USAGE documentation for the install and update generator templates.
- Removed excess shell calls from the CLI template.
- Added Thor::Actions to CLI class template.
- Added "Built with Gemsmith" to README template.
- Updated README template so that Gemfile mention is only provided when Rails is enabled.

# 0.2.0 (2011-06-12)

- Fixed typo in upgrade generator doc.
- Fixed README typo with command line options.
- Added Ruby on Rails skeleton generation support.
- Added RSpec skeleton generation support.
- Added a cli.rb template with basic Thor setup for binary skeletons.
- Added binary executable name to gemspec template for binary skeletons.
- Added gem dependencies to gemspec template for binary and RSpec skeletons.
- Added proper support for underscoring/camelcasing gem names and classes during skeleton generation.
- Added common setup options to the README template.
- Added Ruby on Rails requirements to the README template (only if the Rails options is used).
- Added Ruby on Rails generator templates for installs and upgrades.
- Added Git initialization, addition, and first commit message of all skeleton files during gem creation.
- Updated the gem description.
- Updated the documentation to include Bundler rake tasks.

# 0.1.0 (2011-06-04)

- Initial version.
