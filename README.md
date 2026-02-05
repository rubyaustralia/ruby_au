[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com)

# Ruby Australia Website

[![CI](https://github.com/rubyaustralia/ruby_au/actions/workflows/ci.yml/badge.svg)](https://github.com/rubyaustralia/ruby_au/actions/workflows/ci.yml)

Welcome to the Ruby Australia website repository! This project welcomes contributors of all experience levels.

## Getting Started

👉 **New to the project?** Check out [CONTRIBUTING.md](CONTRIBUTING.md) for detailed setup instructions and contribution guidelines.

👉 **Want mentoring support?** Join our [Mentored Contributions Program](https://ruby.org.au/pages/mentored_contributions) to get paired with an experienced Rubyist.

👉 **Questions?** Join us on [Ruby Australia Slack](https://ruby.org.au/slack) in the `#org-web` channel.

## Project Overview

This is a Rails 8.0+ application using a "lean engines" pattern for managing multiple Ruby community sites:

- **Main App**: Core Ruby Australia website at `ruby.org.au`
- **Site Engines**: City-specific sites in the `sites/` directory (e.g., `melbourne.ruby.org.au`)

**Tech Stack**: Rails + Vite + Hotwire + TailwindCSS + PostgreSQL

## Development

**Setup:**

```bash
bin/install-hooks  # First time only
bin/setup          # Install dependencies and prepare database
```

**Run the app:**

```bash
bin/dev  # Starts Vite + Puma + background jobs
```

**Run tests:**

```bash
bin/tests   # Full test suite (RSpec + Rubocop)
bin/rspec   # RSpec only
```

For detailed setup instructions, troubleshooting, and contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Deployment

Hosted on Heroku with automatic deployment from the `main` branch.

**Live site**: [ruby.org.au](https://ruby.org.au)

## Releases and Versioning

Versioning is automated via GitHub Actions when code is merged into `main`. We follow [Semantic Versioning](https://semver.org/).

The version bump is determined by the commit messages:
- **Major** `(x+1).0.0`: Add `#major` to your commit message (e.g., `Refactor user auth system #major`).
- **Minor** `x.(y+1).0`: Add `#minor` to your commit message (e.g., `Add user profile page #minor`).
- **Patch** `x.y.(z+1)`: Default behavior for all other commits.

A new GitHub Release and Git Tag are automatically created for every push to `main` that successfully passes CI.

## Contributing

We welcome contributions of all kinds! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Detailed setup instructions
- Development workflow
- Code quality standards
- How to submit pull requests

All contributors must follow our [Code of Conduct](CODE_OF_CONDUCT.md).

### CodeTriage

Want to help out but not sure where to start?
Subscribe via [CodeTriage](https://www.codetriage.com/rubyaustralia/ruby_au) to receive a regular email highlighting open issues you can help with.

[![Open Source Helpers](https://www.codetriage.com/rubyaustralia/ruby_au/badges/users.svg)](https://www.codetriage.com/rubyaustralia/ruby_au)

## Known Issues / Gotchas

There have been issues with implementing Trix, the JS file is temporarily in the <HEAD> from the CDN.

Please also refer to [CONTRIBUTING.md](CONTRIBUTING.md)

## License

- **Content**: Copyright 2016 by Ruby Australia, All rights reserved
- **Logotype**: "Ruby Australia" 'Gem' and Typographic logo are Copyright 2016 by Ruby Australia, all rights reserved
