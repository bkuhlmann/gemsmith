# Gemsmith

[![Gem Version](https://badge.fury.io/rb/gemsmith.svg)](http://badge.fury.io/rb/gemsmith)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/gemsmith.svg)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/gemsmith/coverage.svg)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/gemsmith.svg)](https://gemnasium.com/bkuhlmann/gemsmith)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/gemsmith.svg)](https://travis-ci.org/bkuhlmann/gemsmith)
[![Patreon](https://img.shields.io/badge/patreon-donate-brightgreen.svg)](https://www.patreon.com/bkuhlmann)

A command line interface for smithing new Ruby gems.

<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
- [Screencasts](#screencasts)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
  - [Command Line Interface (CLI)](#command-line-interface-cli)
  - [Rake](#rake)
- [Tests](#tests)
- [Security](#security)
  - [Git Signing Key](#git-signing-key)
  - [Gem Certificates](#gem-certificates)
- [Private Gem Servers](#private-gem-servers)
  - [Gem Specification Metadata](#gem-specification-metadata)
  - [Gem Credentials](#gem-credentials)
- [Promotion](#promotion)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features

- Builds a gem skeleton with enhanced Bundler functionality.
- Uses [Versionaire](https://github.com/bkuhlmann/versionaire) for semantic versioning.
- Uses [Milestoner](https://github.com/bkuhlmann/milestoner) for consistent project/gem versioning.
- Uses [Tocer](https://github.com/bkuhlmann/tocer) for README table of contents generation.
- Supports [Thor](https://github.com/erikhuda/thor).
- Supports [Ruby on Rails](http://rubyonrails.org).
- Supports [Pry](http://pryrepl.org).
- Supports [Guard](https://github.com/guard/guard).
- Supports [RSpec](http://rspec.info).
- Supports [Rubocop](https://github.com/bbatsov/rubocop).
- Supports [GitHub](https://github.com).
- Supports [Code Climate](https://codeclimate.com).
- Supports [Gemnasium](https://gemnasium.com).
- Supports [Travis CI](https://travis-ci.org).
- Supports [Patreon](https://www.patreon.com).
- Supports common settings and a structured layout for building new gems.
- Supports publishing to public or private gem servers.
- Provides commonly needed [README](README.md), [CHANGELOG](CHANGELOG.md), [CONTRIBUTING](CONTRIBUTING.md),
  [CODE OF CONDUCT](CODE_OF_CONDUCT.md), [LICENSE](LICENSE.md), etc. documentation.
- Provides the ability to view source code of any gem within your favorite editor.
- Provides the ability to view the documentation of any gem within your default browser.

# Screencasts

[![asciicast](https://asciinema.org/a/30728.png)](https://asciinema.org/a/30728)

# Requirements

0. A UNIX-based system.
0. [Ruby 2.3.x](https://www.ruby-lang.org).
0. [RubyGems](https://rubygems.org).
0. [Bundler](https://github.com/bundler/bundler).

# Setup

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl --location --silent https://www.alchemists.io/gem-public.pem)
    gem install gemsmith --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install gemsmith

You can configure common settings for future gem builds by creating the following file:

    ~/.gemsmithrc

...using the following settings (as a simple example):

    :author:
      :name: "Joe Smith"
      :email: "joe@example.com"
      :url: "https://www.example.com"
    :organization:
      :name: "ExampleSoft"
      :url: "https://www.example.com"

The following defaults are used when no options are configured:

    :year: <current year>
    :github_user: <git config GitHub user>
    :gem:
      :platform: "Gem::Platform::RUBY"
      :home_url: ""
      :license: "MIT"
      :private_key: "~/.ssh/gem-private.pem"
      :public_key: "~/.ssh/gem-public.pem"
    :author:
      :name: <git config user name>
      :email: <git config user email>
      :url: ""
    :organization:
      :name: ""
      :url: ""
    :versions:
      :ruby: <current Ruby version>
      :rails: "5.0"
    :create:
      :cli: false
      :rails: false
      :security: true
      :pry: true
      :guard: true
      :rspec: true
      :rubocop: true
      :git-hub: false
      :code_climate: true
      :gemnasium: true
      :travis: true
      :patreon: true

While Gemsmith is fully customizable, please keep in mind that these are *global* settings and, once set, will affect
all future gem creations. Further customization is also provided via the CLI for a customizable experience per gem if
necessary.

# Usage

## Command Line Interface (CLI)

From the command line, type: `gemsmith --help`

    gemsmith -c, [--create=CREATE]      # Create new gem. DEPRECATED (use --generate).
    gemsmith -e, [--edit]               # Edit gem settings in default editor.
    gemsmith -g, [--generate=GENERATE]  # Generate new gem.
    gemsmith -h, [--help=HELP]          # Show this message or get help for a command.
    gemsmith -o, [--open=OPEN]          # Open a gem in default editor.
    gemsmith -r, [--read=READ]          # Open a gem in default browser.
    gemsmith -v, [--version]            # Show gem version.

For more gem creation options, type: `gemsmith --help --generate`

    -c, [--cli], [--no-cli]                    # Add CLI support.
    -r, [--rails], [--no-rails]                # Add Rails support.
    -S, [--security], [--no-security]          # Add security support.
                                               # Default: true
    -p, [--pry], [--no-pry]                    # Add Pry support.
                                               # Default: true
    -g, [--guard], [--no-guard]                # Add Guard support.
                                               # Default: true
    -s, [--rspec], [--no-rspec]                # Add RSpec support.
                                               # Default: true
    -R, [--rubocop], [--no-rubocop]            # Add Rubocop support.
                                               # Default: true
    -H, [--git-hub], [--no-git-hub]            # Add GitHub support.
    -C, [--code-climate], [--no-code-climate]  # Add Code Climate support.
                                               # Default: true
    -G, [--gemnasium], [--no-gemnasium]        # Add Gemnasium support.
                                               # Default: true
    -t, [--travis], [--no-travis]              # Add Travis CI support.
                                               # Default: true
    -P, [--patreon], [--no-patreon]            # Add Patreon support.
                                               # Default: true

## Rake

Once a gem skeleton has been created, the following tasks are available (i.e. `bundle exec rake -T`):

    rake build                 # Build example-0.1.0.gem into the pkg directory
    rake clean                 # Remove any temporary products / Clean gem artifacts
    rake clobber               # Remove any generated files
    rake console               # Open IRB console for gem development environment
    rake doc                   # Update README (table of contents)
    rake install               # Build and install example-0.1.0.gem into system gems
    rake install:local         # Build and install example-0.1.0.gem into system gems without network access
    rake publish               # Build, tag v0.1.0 (signed), and push example-0.1.0.gem to RubyGems
    rake release[remote]       # Build, tag v0.1.0 (unsigned), and push example-0.1.0.gem to RubyGems
    rake rubocop               # Run RuboCop
    rake rubocop:auto_correct  # Auto-correct RuboCop offenses
    rake spec                  # Run RSpec code examples

Out of all Rake tasks listed above, the following are provided by [Bundler](http://bundler.io) and enhanced by
Gemsmith:

    rake build - Cleans and regenerates the README table of contents in addition to building the gem.
    rake install - Inherits the `build` modifications mentioned above.
    rake install:local - Inherits the `build` modifications mentioned above.
    rake release - Identical to the `publish` tasks but does not securely sign the Git tag.

When building/testing your gem locally, a typical workflow is:

0. `gem uninstall <your gem name>`
0. `bundle exec rake install`
0. Test your gem locally.
0. Repeat until satisfied.

When satified with your gem, builds are green, and ready to publish, run:

    bundle exec rake publish

Alternatively, you can run `bundle exec rake release` if you don't wish to sign your gem releases (i.e default Bundler
behavior) but the added security that `publish` provides is strongly recommended.

# Tests

To test, run:

    bundle exec rake

# Security

## Git Signing Key

To securely sign your Git tags, install and configure [GPG](https://www.gnupg.org):

    brew install gpg
    gpg --gen-key

When creating your GPG key, choose these settings:

- Key kind: RSA and RSA (default)
- Key size: 4096
- Key validity: 0
- Real Name: `<your name>`
- Email: `<your email>`
- Passphrase: `<your passphrase>`

To obtain your key, run the following and take the part after the forward slash:

    gpg --list-keys | grep pub

Add your key to your global Git configuration in the `[user]` section. Example:

    [user]
      signingkey = <your GPG key>

Now, when publishing your gems with Gemsmith (i.e. `bundle exec rake publish`), signing of your Git tag will happen
automatically. You will be prompted for the GPG Passphrase each time but that is to be expected.

## Gem Certificates

To create a certificate for your gems, run the following:

    cd ~/.ssh
    gem cert --build you@example.com
    chmod 600 gem-*.pem

The resulting `*.pem` key files can be referenced via the `:private_key:` and `:public_key:` keys within the
`~/.gemsmithrc` file.

To learn more about gem certificates, read the following:

- [RubyGems](http://guides.rubygems.org/security/#building_gems)
- [A Practical Guide to Using Signed Ruby Gems - Part 1: Bundler](http://blog.meldium.com/home/2013/3/3/signed-rubygems-part)
- [A Practical Guide to Using Signed Ruby Gems - Part 2: Heroku](http://blog.meldium.com/home/2013/3/6/signed-gems-on-heroku)

# Private Gem Servers

By default, the following Rake tasks will publish your gem to [RubyGems](https://rubygems.org):

    rake release
    rake publish

You can change this behavior by adding metadata to your gemspec that will allow the Rake tasks, mentioned above, to
publish your gem to an alternate/private gem server instead. This can be done by updating your gem specification and
RubyGems credentials.

## Gem Specification Metadata

Add the following metadata to your gemspec:

    Gem::Specification.new do |spec|
      spec.metadata = {
        "allowed_push_key" => "example_key",
        "allowed_push_host" => "https://gems.example.com"
      }
    end

The gemspec metadata keys and values *must* be strings per the
[RubyGems Specification](http://guides.rubygems.org/specification-reference/#metadata). Each key represents the
following:

- `allowed_push_key`: Provides a reference (look up) to the key defined the RubyGems credentials file so that sensitive
  credentials are not used within your gemspec.
- `allowed_push_host`: Provides the URL of the private gem server to push your gem to.

## Gem Credentials

With your gem specification metadata established, you are ready to publish your gem to a public or private server. If
this is your first time publishing a gem and no gem credentials have been configured, you'll be prompted for them. Gem
credentials are stored in the RubyGems `~/.gem/credentials` file. From this point forward, future gem publishing will
use your stored credentials instead. Multiple credentials can be stored in the `~/.gem/credentials` file. Example:

    ---
    :rubygems_api_key: 2a0b460650e67d9b85a60e183defa376
    :example_key: "Basic dXNlcjpwYXNzd29yZA=="

Should you need to delete a credential (due to a bad login/password for example), you can open the `~/.gem/credentials`
in your default editor and remove the line(s) you don't need. Upon next publish of your gem, you'll be prompted for the
missing credentials.

# Promotion

Once your gem is released, you might want to let the world know about your accomplishment:

- [How to Spread the Word About Your Code](https://hacks.mozilla.org/2013/05/how-to-spread-the-word-about-your-code)
- [RubyFlow](http://www.rubyflow.com)

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Patch (x.y.Z) - Incremented for small, backwards compatible bug fixes.
- Minor (x.Y.z) - Incremented for new, backwards compatible public API enhancements and/or bug fixes.
- Major (X.y.z) - Incremented for any backwards incompatible public API changes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2011 [Alchemists](https://www.alchemists.io).
Read the [LICENSE](LICENSE.md) for details.

# History

Read the [CHANGELOG](CHANGELOG.md) for details.

# Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at [Alchemists](https://www.alchemists.io).
