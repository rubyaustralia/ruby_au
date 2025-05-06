[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com)

# Ruby Australia Website
[![CI](https://github.com/rubyaustralia/ruby_au/actions/workflows/ci.yml/badge.svg)](https://github.com/rubyaustralia/ruby_au/actions/workflows/ci.yml)

Welcome to the Ruby Australia website repository. All contributions are encouraged.

The slack channel for the website working group can be found
[here](https://rubyau.slack.com/archives/C34D3DCUX).

## Required Environment / Minimum Setup

- [Ruby](https://www.ruby-lang.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Bundler](https://bundler.io/)
- [Yarn](https://yarnpkg.com/)

## Configuration

Clone the project, run the following commands:

```bash
$ git clone https://github.com/rubyaustralia/ruby_au.git
$ cd ruby_au
```

First time set up of the environment, this will bundle gems and install the JS dependencies as well as prepare the database:

```bash
$ bin/install-hooks
$ bin/setup
```

Installing dependencies post set up (after each `git pull`):

```bash
$ bundle install
$ yarn install
```

## Running the Development Environment

This command will run using Foreman and start the app using both webpack and puma.

```bash
$ bin/dev
```

## Running the Test Environment

A full test (Rspec and Rubocop) including preparing the database and running migrations can be run with:

```bash
$ bin/tests
```

Tests are written in RSpec. They are located in the `spec` directory and can be run with:

```bash
$ bin/rspec
```

## Production Environment

This website is hosted on Heroku and is deployed automatically when a new commit is pushed to the main branch.

You can see it in action here:
[ruby australia](https://ruby.org.au)

## Known Issues / Gotchas

None (yet) but please see [CONTRIBUTING.md](CONTRIBUTING.md)

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Content licence

Content is Copyright 2016 by Ruby Australia, All rights reserved.

## Logotype licence

"Ruby Australia" 'Gem' and Typographic logo are Copyright 2016 by Ruby Australia, all rights reserved.

## Contact

For any questions or feedback, please contact the website working group on [Slack](https://rubyau.slack.com/archives/C34D3DCUX).
