# Gemsmith

[![Gem Version](https://badge.fury.io/rb/gemsmith.svg)](http://badge.fury.io/rb/gemsmith)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/gemsmith.svg)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/gemsmith/coverage.svg)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/gemsmith.svg)](https://gemnasium.com/bkuhlmann/gemsmith)
[![Circle CI Status](https://circleci.com/gh/bkuhlmann/gemsmith.svg?style=svg)](https://circleci.com/gh/bkuhlmann/gemsmith)
[![Patreon](https://img.shields.io/badge/patreon-donate-brightgreen.svg)](https://www.patreon.com/bkuhlmann)

A command line interface for smithing new Ruby gems.

<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
- [Screencasts](#screencasts)
- [Requirements](#requirements)
- [Setup](#setup)
  - [Install](#install)
  - [Configuration](#configuration)
  - [Existing Gems](#existing-gems)
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
- [Troubleshooting](#troubleshooting)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features

- Builds a gem skeleton with enhanced Bundler functionality.
- Uses [Refinements](https://github.com/bkuhlmann/refinements) Ruby core library enhancements.
- Uses [Versionaire](https://github.com/bkuhlmann/versionaire) for semantic versioning.
- Uses [Runcom](https://github.com/bkuhlmann/runcom) for resource configuration management.
- Uses [Milestoner](https://github.com/bkuhlmann/milestoner) for consistent project/gem versioning.
- Uses [Pragmater](https://github.com/bkuhlmann/pragmater) for Ruby source pragma directives.
- Uses [Tocer](https://github.com/bkuhlmann/tocer) for README table of contents generation.
- Supports [Thor](https://github.com/erikhuda/thor).
- Supports [Ruby on Rails](http://rubyonrails.org).
- Supports [RubyGems Security](http://guides.rubygems.org/security).
- Supports [Pry](http://pryrepl.org).
- Supports [Guard](https://github.com/guard/guard).
- Supports [RSpec](http://rspec.info).
- Supports [Reek](https://github.com/troessner/reek).
- Supports [Rubocop](https://github.com/bbatsov/rubocop).
- Supports [SCSS Lint](https://github.com/brigade/scss-lint).
- Supports [GitHub](https://github.com).
- Supports [Code Climate](https://codeclimate.com).
- Supports [Gemnasium](https://gemnasium.com).
- Supports [Travis CI](https://travis-ci.org).
- Supports [Patreon](https://www.patreon.com).
- Supports common settings and a structured layout for building new gems.
- Supports publishing to public or private gem servers.
- Provides common documentation:
  - [README](README.md)
  - [CHANGES](CHANGES.md)
  - [CONTRIBUTING](CONTRIBUTING.md)
  - [CODE OF CONDUCT](CODE_OF_CONDUCT.md)
  - [LICENSE](LICENSE.md)
- Aids in viewing source code of semantically versioned gems within your favorite editor.
- Aids in viewing documentation of semantically versioned within your default browser.

# Screencasts

[![asciicast](https://asciinema.org/a/92550.png)](https://asciinema.org/a/92550)

# Requirements

0. A UNIX-based system.
0. [Ruby 2.4.x](https://www.ruby-lang.org).
0. [RubyGems](https://rubygems.org).
0. [Bundler](https://github.com/bundler/bundler).

# Setup

## Install

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl --location --silent https://www.alchemists.io/gem-public.pem)
    gem install gemsmith --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification
while allowing the installation of unsigned dependencies since they are beyond the scope of this
gem.

For an insecure install, type the following (not recommended):

    gem install gemsmith

## Configuration

You can configure common settings for future gem builds by creating the following file:

    ~/.gemsmithrc

The following defaults are used when no options are configured:

    :year: <current year>
    :github_user: "<Git config GitHub user>",
    :gem:
      :name: "undefined"
      :path: "undefined"
      :class: "Undefined"
      :platform: "Gem::Platform::RUBY"
      :url: "https://github.com/<author>/<gem name>"
      :license: "MIT"
    :author:
      :name: "<Git config user name>"
      :email: "<Git config user email>"
      :url: ""
    :organization:
      :name: ""
      :url: ""
    :versions:
      :ruby: "<current Ruby version>"
      :rails: "5.0"
    :generate:
      :cli: false
      :rails: false
      :security: true
      :pry: true
      :guard: true
      :rspec: true
      :reek: true
      :rubocop: true
      :scss_lint: false
      :git_hub: false
      :code_climate: false
      :gemnasium: false
      :travis: false
      :patreon: false
    :publish:
      :sign: false

While Gemsmith is fully customizable, please keep in mind that these are *global* settings and, once
set, will affect all future gem creations. Further customization is also provided via the CLI for a
customizable experience per gem if necessary.

## Existing Gems

If you have gems that were not originally crafted by Gemsmith, you can add Gemsmith support to them
by modifying the following files:

Add the following to your gem's `*.gemspec` file:

    spec.add_development_dependency "gemsmith"

Replace or add a modified version of the following to your gem's `Rakefile`:

    # frozen_string_literal: true

    begin
      require "gemsmith/rake/setup"
    rescue LoadError => error
      puts error.message
    end

*NOTE: Ensure `require "bundler/gem_tasks"` is removed as Gemsmith replaces Bundler functionality.*

With those changes, you can leverage the benefits of Gemsmith within your existing gem.

# Usage

## Command Line Interface (CLI)

From the command line, type: `gemsmith --help`

    gemsmith -c, [--config]        # Manage gem configuration.
    gemsmith -g, [--generate=GEM]  # Generate new gem.
    gemsmith -h, [--help=COMMAND]  # Show this message or get help for a command.
    gemsmith -o, [--open=GEM]      # Open a gem in default editor.
    gemsmith -r, [--read=GEM]      # Open a gem in default browser.
    gemsmith -v, [--version]       # Show gem version.

For more gem generation options, type: `gemsmith --help --generate`

    [--cli], [--no-cli]                    # Add CLI support.
    [--rails], [--no-rails]                # Add Rails support.
    [--security], [--no-security]          # Add security support.
                                           # Default: true
    [--pry], [--no-pry]                    # Add Pry support.
                                           # Default: true
    [--guard], [--no-guard]                # Add Guard support.
                                           # Default: true
    [--rspec], [--no-rspec]                # Add RSpec support.
                                           # Default: true
    [--reek], [--no-reek]                  # Add Reek support.
                                           # Default: true
    [--rubocop], [--no-rubocop]            # Add Rubocop support.
                                           # Default: true
    [--scss-lint], [--no-scss-lint]        # Add SCSS Lint support.
    [--git-hub], [--no-git-hub]            # Add GitHub support.
    [--code-climate], [--no-code-climate]  # Add Code Climate support.
    [--gemnasium], [--no-gemnasium]        # Add Gemnasium support.
    [--travis], [--no-travis]              # Add Travis CI support.
    [--patreon], [--no-patreon]            # Add Patreon support.

## Rake

Once a gem skeleton has been created, the following tasks are available (i.e. `bundle exec rake
-T`):

    rake build                 # Build gemsmith-9.6.0.gem package
    rake clean                 # Clean gem artifacts
    rake code_quality          # Run code quality checks
    rake doc                   # Update README (table of contents)
    rake install               # Install gemsmith-9.6.0.gem package
    rake publish               # Build, tag as v9.6.0 (signed), and push gemsmith-9.6.0.gem to RubyGems
    rake reek                  # Check for code smells
    rake rubocop               # Run RuboCop
    rake rubocop:auto_correct  # Auto-correct RuboCop offenses
    rake spec                  # Run RSpec code examples

When building/testing your gem locally, a typical workflow is:

0. `bundle exec rake install`
0. Test your gem locally.
0. Repeat until satisfied.

When satified with your gem, builds are green, and ready to publish, run:

    bundle exec rake publish

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

Now, when publishing your gems with Gemsmith (i.e. `bundle exec rake publish`), signing of your Git
tag will happen automatically. You will be prompted for the GPG Passphrase each time but that is to
be expected.

## Gem Certificates

To create a certificate for your gems, run the following:

    cd ~/.ssh
    gem cert --build you@example.com
    chmod 600 gem-*.pem

The resulting `*.pem` key files can be referenced via the `:private_key:` and `:public_key:` keys
within the `~/.gemsmithrc` file.

To learn more about gem certificates, read the following:

- [RubyGems](http://guides.rubygems.org/security/#building_gems)
- [A Practical Guide to Using Signed Ruby Gems - Part 1: Bundler](http://blog.meldium.com/home/2013/3/3/signed-rubygems-part)
- [A Practical Guide to Using Signed Ruby Gems - Part 2: Heroku](http://blog.meldium.com/home/2013/3/6/signed-gems-on-heroku)

# Private Gem Servers

By default, the following Rake task will publish your gem to [RubyGems](https://rubygems.org):

    bundle exec rake publish

You can change this behavior by adding metadata to your gemspec that will allow the Rake tasks,
mentioned above, to publish your gem to an alternate/private gem server instead. This can be done by
updating your gem specification and RubyGems credentials.

## Gem Specification Metadata

Add the following metadata to your gemspec:

    Gem::Specification.new do |spec|
      spec.metadata = {
        "allowed_push_key" => "example_key",
        "allowed_push_host" => "https://gems.example.com"
      }
    end

The gemspec metadata keys and values *must* be strings per the
[RubyGems Specification](http://guides.rubygems.org/specification-reference/#metadata). Each key
represents the following:

- `allowed_push_key`: Provides a reference (look up) to the key defined the RubyGems credentials
  file so that sensitive credentials are not used within your gemspec.
- `allowed_push_host`: Provides the URL of the private gem server to push your gem to.

## Gem Credentials

With your gem specification metadata established, you are ready to publish your gem to a public or
private server. If this is your first time publishing a gem and no gem credentials have been
configured, you'll be prompted for them. Gem credentials are stored in the RubyGems
`~/.gem/credentials` file. From this point forward, future gem publishing will use your stored
credentials instead. Multiple credentials can be stored in the `~/.gem/credentials` file. Example:

    ---
    :rubygems_api_key: 2a0b460650e67d9b85a60e183defa376
    :example_key: "Basic dXNlcjpwYXNzd29yZA=="

Should you need to delete a credential (due to a bad login/password for example), you can open the
`~/.gem/credentials` in your default editor and remove the line(s) you don't need. Upon next publish
of your gem, you'll be prompted for the missing credentials.

# Promotion

Once your gem is released, you might want to let the world know about your accomplishment:

- [How to Spread the Word About Your Code](https://hacks.mozilla.org/2013/05/how-to-spread-the-word-about-your-code)
- [RubyFlow](http://www.rubyflow.com)

# Troubleshooting

When running `bundle exec rake install` or `bundle exec rake publish` with modified, staged, or
uncommitted Git changes, the rake task will throw an error to this effect. When this occurs, it is
recommended that you commit your changes or [stash](https://git-scm.com/docs/git-stash) them before
proceeding.

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2011 [Alchemists](https://www.alchemists.io).
Read [LICENSE](LICENSE.md) for details.

# History

Read [CHANGES](CHANGES.md) for details.

# Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at
[Alchemists](https://www.alchemists.io).
