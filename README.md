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

`bin/rspec`

## Development Environment

This command will run using Foreman and start the app using both webpack and puma.

$ bin/dev

## Production Environment

This website is hosted on Heroku

You can see it in action here:
[ruby australia](https://ruby.org.au)

## Known Issues / Gotchas

None (yet).

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## Content licence

Content is Copyright 2016 by Ruby Australia, All rights reserved.

## Logotype licence

"Ruby Australia" 'Gem' and Typographic logo are Copyright 2016 by Ruby Australia,
All rights reserved.
