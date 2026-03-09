# Copilot Instructions for Ruby Australia Website

This guide helps AI coding agents work productively in the Ruby Australia website codebase. It summarizes key architecture, workflows, and conventions unique to this project.

## Architecture Overview
- **Rails 8.0+ monorepo** with modular city/community sites using Zeitwerk auto-namespacing.
- **Main app**: Core Ruby Australia site (`ruby.org.au`).
- **City sites**: Each city (e.g., `melbourne/`) is a site in `sites/`, with automatic namespace isolation via Zeitwerk.
- **Frontend**: Uses Vite, Hotwire, and TailwindCSS. Entry points in `app/frontend/entrypoints/`.
- **Database**: Main DB is PostgreSQL. Some sites (e.g., Melbourne) use YAML files (see `sites/melbourne/db/data/events.yml`) for event data.

## Developer Workflows
- **Setup**: Run `bin/install-hooks` (once) then `bin/setup` to install dependencies and prepare the DB.
- **Start app**: Use `bin/dev` (runs Vite, Puma, background jobs).
- **Run tests**: Use `bin/tests` for full suite (RSpec + Rubocop), or `bin/rspec` for RSpec only.
- **Deploy**: Main branch auto-deploys to Heroku.

## Conventions & Patterns
- **City Sites**: Each site is self-contained with its own MVC structure, routes, specs, and data. Namespacing is automatic — files in `sites/melbourne/app/` are automatically under `Melbourne::`.
- **Routes**: Site routes are drawn into the main app via `draw(:<city>)` in `config/routes.rb` with subdomain constraints.
- **YAML Data**: For Melbourne, events/talks/speakers are managed in `sites/melbourne/db/data/events.yml`. New events go at the top. See `sites/melbourne/README.md` for required fields.
- **Frontend assets**: Images (e.g., sponsor logos) should be 500x150px, white background (`app/frontend/images/sponsors/`).
- **Contribution**: See `CONTRIBUTING.md` for setup, troubleshooting, and guidelines. Mentoring available via the Mentored Contributions Program.

## Integration Points
- **Slack**: Community support in `#org-web` channel.
- **Heroku**: Automatic deployment from `main` branch.
- **CI**: GitHub Actions (`.github/workflows/ci.yml`).

## Key Files & Directories
- `sites/<city>/config/initializers/root.rb`: Site root path and route helpers.
- `sites/<city>/config/routes/<city>.rb`: Site routes with subdomain constraints.
- `sites/<city>/db/data/events.yml`: Event/talk/speaker data.
- `sites/README.md`: Full documentation of the sites architecture.
- `app/frontend/entrypoints/`: JS entry points for Vite.
- `app/frontend/images/sponsors/`: Sponsor logo assets.
- `CONTRIBUTING.md`: Contribution and setup details.

## Example: Adding a New City Site
1. Create the directory structure following `sites/melbourne/` as a template.
2. Create `sites/<city>/config/initializers/root.rb` with the site's root path and routes module.
3. Create `sites/<city>/config/routes/<city>.rb` with subdomain-constrained routes.
4. Add `draw(:<city>)` to `config/routes.rb`.
5. See `sites/README.md` for full details.

---
For questions or mentoring, join Ruby Australia Slack `#org-web`.

_Last updated: 2026-03-09_
