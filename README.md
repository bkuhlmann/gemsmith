# Gemsmith

[![Gem Version](https://badge.fury.io/rb/gemsmith.svg)](http://badge.fury.io/rb/gemsmith)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/gemsmith.svg)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/gemsmith/coverage.svg)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/gemsmith.svg)](https://gemnasium.com/bkuhlmann/gemsmith)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/gemsmith.svg)](http://travis-ci.org/bkuhlmann/gemsmith)
[![Patreon](https://img.shields.io/badge/patreon-donate-brightgreen.svg)](https://www.patreon.com/bkuhlmann)

A command line interface for smithing new Ruby gems.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
  - [Command Line Interface (CLI)](#command-line-interface-cli)
  - [Rake](#rake)
  - [Upgrades](#upgrades)
- [Tests](#tests)
- [Security](#security)
  - [Git Signing Key](#git-signing-key)
  - [Gem Certificates](#gem-certificates)
- [Promotion](#promotion)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Features

- Builds a gem skeleton with Bundler functionality in mind.
- Supports common settings to be applied when creating new gems.
- Supports [Thor](https://github.com/wycats/thor) command line functionality.
- Supports [Ruby on Rails](http://rubyonrails.org).
- Supports [RSpec](http://rspec.info).
- Supports [Rubocop](https://github.com/bbatsov/rubocop).
- Supports [Pry](http://pryrepl.org).
- Supports [Guard](https://github.com/guard/guard).
- Supports [Code Climate](https://codeclimate.com).
- Supports [Gemnasium](https://gemnasium.com).
- Supports [Travis CI](http://travis-ci.org).
- Provides the ability to open the source code of any gem within your favorite editor.
- Provides the ability to read the documentation of any gem within your default browser.
- Adds commonly needed [README](README.md), [CHANGELOG](CHANGELOG.md), [CONTRIBUTING](CONTRIBUTING.md),
  [LICENSE](LICENSE.md), etc. template files.

# Requirements

0. A UNIX-based system.
0. [MRI 2.x.x](http://www.ruby-lang.org).
0. [RubyGems](http://rubygems.org).
0. [Bundler](https://github.com/carlhuda/bundler).

# Setup

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl -Ls https://www.alchemists.io/gem-public.pem)
    gem install gemsmith --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install gemsmith

You can configure common settings for future gem builds by creating the following file:

    ~/.gemsmith/settings.yml

...using the following settings (for example):

    ---
    :author_name: Joe Smith
    :author_email: joe@smithware.com
    :author_url: https://www.smithware.com
    :company_name: Smithware

If no options are configured, then the defaults are as follows:

    gem_platform: Gem::Platform::RUBY
    gem_private_key: ~/.ssh/gem-private.pem
    gem_public_key: ~/.ssh/gem-public.pem
    author_name: <git name>
    author_email: <git email>
    author_url: https://www.unknown.com
    gem_url: <author URL>
    company_name: <author name>
    company_url: <author URL>
    github_user: <github user>
    year: <current year>
    ruby_version: 2.2.0
    rails_version: 4.2

# Usage

## Command Line Interface (CLI)

From the command line, type: gemsmith help

    gemsmith -c, [create=CREATE]  # Create new gem.
    gemsmith -e, [--edit]         # Edit Gemsmith settings in default editor.
    gemsmith -h, [--help=HELP]    # Show this message or get help for a command.
    gemsmith -o, [open=OPEN]      # Open a gem in default editor.
    gemsmith -r, [read=READ]      # Open a gem in default browser.
    gemsmith -v, [--version]      # Show Gemsmith version.

For more gem creation options, type: gemsmith help create

    -b, [--bin], [--no-bin]                    # Add binary support.
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
    -c, [--code-climate], [--no-code-climate]  # Add Code Climate support.
                                               # Default: true
    -G, [--gemnasium], [--no-gemnasium]        # Add Gemnasium support.
                                               # Default: true
    -t, [--travis], [--no-travis]              # Add Travis CI support.
                                               # Default: true

## Rake

Once a gem skeleton has been created, the following tasks are available within the project via Bundler (i.e. rake -T):

    rake build                 # Build example-0.1.0.gem into the pkg directory
    rake clean                 # Clean gem artifacts
    rake install               # Build and install example-0.1.0.gem into system gems
    rake install:local         # Build and install example-0.1.0.gem into system gems without network access
    rake publish               # Build, tag v0.1.0 (signed), and push example-0.1.0.gem to RubyGems
    rake readme:toc            # Update README Table of Contents
    rake release               # Create tag v0.1.0 and build and push example-0.1.0.gem to Rubygems
    rake rubocop               # Run RuboCop
    rake rubocop:auto_correct  # Auto-correct RuboCop offenses
    rake spec                  # Run RSpec code examples

## Upgrades

For those upgrading from Gemsmith 5.3.0 and wanting to use the new Rake tasks, do the following:

- Edit your `gemspec` and add the following dependency: `spec.add_development_dependency "gemsmith"`.
- Edit your `Rakefile` and remove the Bundler requirement `require "bundler/gem_tasks"` and replace it with
  the Gemsmith tasks: `require "gemsmith/rake/setup"`. Don't worry, this includes the Bundler tasks too.

# Tests

To test, run:

    bundle exec rake

# Security

## Git Signing Key

To sign your Git tags, start by installing and configuring [GPG](https://www.gnupg.org):

    brew install gpg
    gpg --gen-key

When setting up your GPG key, here is an example of safe defaults:

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
automatically. Should you not want to sign your tags, use `bundle exec rake release` which is the same as
`bundle exec rake publish` except the Git tag is not signed.

## Gem Certificates

To create a certificate for your gems, run the following:

    cd ~/.ssh
    gem cert --build you@example.com
    chmod 600 gem-*.pem

The resulting *.pem keys can be referenced via the *gem_private_key- and *gem_public_key- settings mentioned in the
Setup documentation.

To learn more about gem certificates, read the following:

- [Ruby Gems](http://guides.rubygems.org/security/#building_gems)
- [A Practical Guide to Using Signed Ruby Gems - Part 1: Bundler](http://blog.meldium.com/home/2013/3/3/signed-rubygems-part)
- [A Practical Guide to Using Signed Ruby Gems - Part 2: Heroku](http://blog.meldium.com/home/2013/3/6/signed-gems-on-heroku)

# Promotion

Once your gem is released, you might like to let the world know about the new awesomeness. Here are several resources:

- [How to Spread the Word About Your Code](https://hacks.mozilla.org/2013/05/how-to-spread-the-word-about-your-code)
- [Ruby Toolbox](https://www.ruby-toolbox.com)
- [RubyFlow](http://www.rubyflow.com)
- [The Ruby Show](http://rubyshow.com)
- [Ruby 5](https://ruby5.codeschool.com)

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
