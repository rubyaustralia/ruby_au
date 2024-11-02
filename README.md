# Ruby Australia Website

Website for Ruby Australia
The slack channel for the website working group can be found
[here](https://rubyau.slack.com/messages/ruby-au-website/)

## Required Environment / Minimum Setup

- Install the Ruby version (`3.3.5`).
- Install PostgreSQL.
- Install Bundler.
- `bundle install`
- Install yarn.
- `yarn install`
- Modify `config/database.yml` as needed.
- `rake db:setup`

## Configuration

None (yet).

## Testing

A full test (Rspec and Rubocop) including database migrations can be run with:

`bin/rails test`

Tests are written in RSpec. They are located in the `spec` directory and can be run with:

`bin/rspec`

## Development Environment

This command will run using Foreman and start the app using both webpack and puma.

$ bin/dev

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

"Ruby Australia" 'Gem' and Typographic logo are Copyright 2016 by Ruby Australia,
All rights reserved.
