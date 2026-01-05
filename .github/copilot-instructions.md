# Copilot Instructions for Ruby Australia Website

This guide helps AI coding agents work productively in the Ruby Australia website codebase. It summarizes key architecture, workflows, and conventions unique to this project.

## Architecture Overview
- **Rails 8.0+ monorepo** using "lean engines" for modular city/community sites.
- **Main app**: Core Ruby Australia site (`ruby.org.au`).
- **Site engines**: Each city (e.g., `melbourne/`) is a Rails Engine in `sites/`, registered in `config/application.rb` and loaded via `sites/<city>/lib/<city>.rb`.
- **Frontend**: Uses Vite, Hotwire, and TailwindCSS. Entry points in `app/frontend/entrypoints/`.
- **Database**: Main DB is PostgreSQL. Some engines (e.g., Melbourne) use YAML files (see `db/data/events.yml`) for event data.

## Developer Workflows
- **Setup**: Run `bin/install-hooks` (once) then `bin/setup` to install dependencies and prepare the DB.
- **Start app**: Use `bin/dev` (runs Vite, Puma, background jobs).
- **Run tests**: Use `bin/tests` for full suite (RSpec + Rubocop), or `bin/rspec` for RSpec only.
- **Deploy**: Main branch auto-deploys to Heroku.

## Conventions & Patterns
- **Lean Engines**: Each engine is minimal, only including code/data for its subdomain. Registered in `config/application.rb` and loaded via `lib/<city>.rb` and `lib/<city>/engine.rb`.
- **YAML Data**: For Melbourne, events/talks/speakers are managed in `db/data/events.yml`. New events go at the top. See `sites/melbourne/README.md` for required fields.
- **Frontend assets**: Images (e.g., sponsor logos) should be 500x150px, white background (`app/frontend/images/sponsors/`).
- **Contribution**: See `CONTRIBUTING.md` for setup, troubleshooting, and guidelines. Mentoring available via the Mentored Contributions Program.

## Integration Points
- **Slack**: Community support in `#org-web` channel.
- **Heroku**: Automatic deployment from `main` branch.
- **CI**: GitHub Actions (`.github/workflows/ci.yml`).

## Key Files & Directories
- `config/application.rb`: Registers site engines.
- `sites/<city>/lib/<city>.rb`: Engine entry point.
- `sites/<city>/lib/<city>/engine.rb`: Engine definition.
- `db/data/events.yml`: Event/talk/speaker data for Melbourne.
- `app/frontend/entrypoints/`: JS entry points for Vite.
- `app/frontend/images/sponsors/`: Sponsor logo assets.
- `CONTRIBUTING.md`: Contribution and setup details.

## Example: Registering a New Site Engine
1. Create `sites/<city>/` with `lib/<city>.rb` and `lib/<city>/engine.rb`.
2. Add `require_relative "../sites/<city>/lib/<city>"` to `config/application.rb`.
3. Follow the lean engine pattern (see [Julian Pinzon's talk](https://www.youtube.com/watch?v=StDoHXO8H6E)).

---
For questions or mentoring, join Ruby Australia Slack `#org-web`.

_Last updated: 2025-12-06_
