# Overview

[![Gem Version](https://badge.fury.io/rb/gemsmith.png)](http://badge.fury.io/rb/gemsmith)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/gemsmith.png)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/gemsmith/coverage.png)](https://codeclimate.com/github/bkuhlmann/gemsmith)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/gemsmith.png)](https://gemnasium.com/bkuhlmann/gemsmith)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/gemsmith.png)](http://travis-ci.org/bkuhlmann/gemsmith)
[![Gittip](http://img.shields.io/gittip/bkuhlmann.svg)](https://www.gittip.com/bkuhlmann)

Gemsmith allows you to easily craft new gems via the command line with custom settings (if desired).

# Features

- Builds a gem skeleton with Bundler functionality in mind.
- Supports common settings to be applied when creating new gems.
- Supports [Thor](https://github.com/wycats/thor) command line functionality.
- Supports [Ruby on Rails](http://rubyonrails.org).
- Supports [RSpec](http://rspec.info).
- Supports [Pry](http://pryrepl.org).
- Supports [Guard](https://github.com/guard/guard).
- Supports [Code Climate](https://codeclimate.com).
- Supports [Gemnasium](https://gemnasium.com).
- Supports [Travis CI](http://travis-ci.org).
- Provides the ability to open the source code of any gem within your favorite editor.
- Provides the ability to read the documentation of any gem within your default browser.
- Adds commonly needed README, [CHANGELOG](CHANGELOG.md), [CONTRIBUTING](CONTRIBUTING.md), [LICENSE](LICENSE.md), etc.
  template files.

# Requirements

0. A UNIX-based system.
0. Any of the following Ruby VMs:
    - [MRI 2.x.x](http://www.ruby-lang.org)
    - [JRuby 1.x.x](http://jruby.org)
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

From the command line, type: gemsmith help

    gemsmith -c, [create=CREATE]  # Create new gem.
    gemsmith -e, [edit]           # Edit gem in default editor (assumes $EDITOR environment variable).
    gemsmith -h, [--help=HELP]    # Show this message or get help for a command.
    gemsmith -o, [open=OPEN]      # Open gem in default editor (assumes $EDITOR environment variable).
    gemsmith -r, [read=READ]      # Open gem in default browser.
    gemsmith -v, [--version]      # Show version.

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
    -c, [--code-climate], [--no-code-climate]  # Add Code Climate support.
                                               # Default: true
    -G, [--gemnasium], [--no-gemnasium]        # Add Gemnasium support.
                                               # Default: true
    -t, [--travis], [--no-travis]              # Add Travis CI support.
                                               # Default: true

Once a gem skeleton has been created, the following tasks are available within the project via Bundler (i.e. rake -T):

    rake build    # Build example-0.1.0.gem into the pkg directory
    rake install  # Build and install example-0.1.0.gem into system gems
    rake release  # Create tag v2.3.0 and build and push example-0.1.0.gem to Rubygems

# Tests

To test, run:

    bundle exec rspec spec

# Security

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

# Best Practices

0. [Semantic Versioning](http://semver.org)
0. [Best Practices While Cutting Gems](http://rubysource.com/crafting-rubies-best-practices-while-cutting-gems).
0. [Ruby on Rails Gem Packaging](http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices).
0. [Gem Activation and You: Part I](http://erik.hollensbe.org/2013/05/11/gem-activation-and-you)
0. [Gem Activation and You: Part II](http://erik.hollensbe.org/2013/05/15/gem-activation-and-you-part-2-bundler-and-binstubs)
0. [Why You Should Use a BSD Style License](http://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html).
0. Add -w to the RUBYOPT environment variable when testing. [Details](http://avdi.org/devblog/2011/06/23/how-ruby-helps-you-fix-your-broken-code).

# Documentation

In order to make your gem easier to use and adopt by others, good documentation is always a plus. Consider submitting
your gem to RubyDocs[http://rubydoc.info] once your gem is released and available for use. RubyDocs supports both
RDoc and YARD formats.

# Promotion

Once your gem is released, you might like to let the world know about the new awesomeness. Here are several resources:

- [How to Spread the Word About Your Code](https://hacks.mozilla.org/2013/05/how-to-spread-the-word-about-your-code)
- [Ruby Toolbox](https://www.ruby-toolbox.com)
- [RubyFlow](http://www.rubyflow.com)
- [The Ruby Show](http://rubyshow.com)
- [Ruby 5](http://ruby5.envylabs.com)

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
