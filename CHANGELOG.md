# v5.1.0 (2015-07-05)

- Removed JRuby support (no longer officially supported).
- Fixed secure gem installs (new cert has 10 year lifespan).
- Updated to Ruby 2.2.2.
- Added CLI process title support.
- Added code of conduct documentation.

# v5.0.0 (2015-01-01)

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

# v4.3.0 (2014-10-22)

- Updated to Thor+ 1.7.x.
- Updated gemspec author email address.

# v4.2.0 (2014-09-21)

- Updated to Ruby 2.1.3.
- Updated Code Climate to run only if environment variable is present.
- Added the Guard Terminal Notifier gem.
- Refactored RSpec setup and support files.

# v4.1.0 (2014-08-10)

- Updated --rails flag of --create option to support full Rails Engine template creation.
- Updated RSpec config to verify partial doubles.
- Updated gemspec to add security keys unless in a CI environment.

# v4.0.0 (2014-08-03)

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

# v3.2.0 (2014-07-06)

- Added Code Climate test coverage support.
- Updated to Ruby 2.1.2.
- Updated gem-public.pem for gem install certificate chain.

# v3.1.0 (2014-04-16)

- Updated to Thor 0.19.x.
- Updated to Thor+ 1.5.x.
- Updated RSpec helper to disable GC for all specs in order to improve performance.

# v3.0.0 (2014-03-25)

- Removed the pry-vterm_aliases gem.
- Updated to MRI 2.1.1.
- Updated to Rubinius 2.x.x support.
- Updated to Rails 4.0.
- Updated README with --trust-policy for secure install of gem.
- Added Gemnasium badge support.
- Added Coveralls badge support.
- Added security support (including customization) of gem signing key and cert chain.
- Added JRuby and Rubinius support to gem skeleton generation.

# v2.4.0 (2014-02-15)

- Added JRuby and Rubinius VM support.

# v2.3.0 (2014-01-26)

- Added gem certificate information to the README security section.
- Updated new skeleton Git commit message.
- Updated gem-public.pem to default to ~/.ssh in gemspec template.
- Updated gem option descriptions.
- Updated gemspec homepage URL to use GitHub project URL.

# v2.2.0 (2013-12-28)

- Fixed long-form commands to use "--" prefix. Example: --example.
- Fixed Ruby Gem certificate requirements for package building.
- Fixed RSpec deprecation warnings for treating metadata symbol keys as true values.
- Removed UTF-8 encoding definitions - This is the default in Ruby 2.x.x.
- Removed .ruby-version from .gitignore.
- Removed Linux Guard notification support.
- Updated to Ruby 2.1.0.
- Updated the ignoring of signing a gem when building in a Travis CI environment.
- Updated public gem certificate to be referenced from a central server.
- Added a Versioning section to the README as defined here: http://semver.org.
- Added public cert for secure install of gem.
- Added Pry plugin requirements to RSpec spec helper.

# v2.1.0 (2013-06-15)

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

# v2.0.0 (2013-03-17)

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

# v1.5.0 (2012-05-19)

- Added auto-linking to GitHub Issues via README template.
- Relaxed Rails gem settings to 3.x.x.
- Switched gem dependency to Thor 0.x.x range.
- Switched gem dependency to Thor+ 0.x.x range.

# v1.4.0 (2012-01-29)

- Added Travis CI templates for Rails build matrix that can support multiple version tests.
- Added vendor files to gemspec template so they are included when building a new gem (especially Rails related).
- Moved library requirements within the Rails conditional check so that requirements are only loaded if Rails is detected.
- Modified the RSpec development dependency so that if Rails is detected, the rspec-rails gem is included instead.
- Changed the Rails default version to 3.2.0.

# v1.3.0 (2012-01-14)

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

# v1.2.0 (2012-01-02)

- Updated README and README template with new layout for test instructions.
- Upgraded to Thor+ 0.2.0 and removed the settings_file, settings, and load_settings methods.
- Added Why You Should Use a BSD license to the README Best Practices section.
- Added the Best Practices While Cutting Gems to the Best Practices section of the README.
- Added the ruby warning and encoding option formats to the binary template.
- Removed the do block from RSpec template so that initial tests show pending instead of successful results.

# v1.1.0 (2011-11-20)

- Fixed bug where args, options, and config were not being passed to super for CLI initialize for gem and gem template generation.
- Updated gemspec settings and removed rubygem requirements from spec helper.
- Defaulted RSpec output to documentation format for project and template generation.
- Added Ruby on Rails Gem Packaging to Best Practices section of README.
- Added the -o option for opening a gem in the default editor.
- Added RSpec documentation to README and README template.
- Added Tests, Contributions, and Credits section to README and README template.

# v1.0.0 (2011-10-29)

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

# v0.5.0 (2011-08-27)

- Fixed bug with wrong definition of ActionView instance method include for main gem template.
- Changed the ActionView template behavior so that instance methods are auto-included.
- Renamed the execute methods for the install and upgrade generators to install and upgrade respectively.
- Added Rails version options. Default: 3.0.0.
- Added Ruby version option. Default: 1.9.2.
- Made the module namespace optional when building gems specifically for Rails.
- Relabeled the TODO helper text for all templates.

# v0.4.0 (2011-07-31)

- Fixed bug with options not being supplied as second argument to write_inheritable_attribute for ActionController and ActiveRecord class method templates.
- Changed the -R option to -r for Rails and added the -s option for RSpec.
- Trimmed ERB whitespace from templates where apt.
- Cleaned up the source_root code for both the install and upgrade generator templates.
- Renamed the copy_files method to the execute method for both the install and upgrade generator templates.
- Moved desc method next to execution method for both the install and upgrade generator templates.
- Removed the banners from the install and upgrade generator templates since this is auto-generated by Thor.

# v0.3.0 (2011-07-10)

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

# v0.2.0 (2011-06-12)

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

# v0.1.0 (2011-06-04)

- Initial version.
