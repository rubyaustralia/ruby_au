# Copilot Instructions for Ruby Australia Website

This guide helps AI coding agents work productively in the Ruby Australia website codebase. It summarizes key architecture, workflows, and conventions unique to this project.

## Architecture Overview
- **Rails 8.0+ monorepo** using [packs-rails](https://github.com/rubyatscale/packs-rails) with [automatic_namespaces](https://github.com/rubyatscale/automatic_namespaces) for modular city/community sites.
- **Main app**: Core Ruby Australia site (`ruby.org.au`).
- **City packs**: Each city (e.g., `melbourne/`) is a pack in `packs/`, with automatic namespace isolation via `package.yml`.
- **Frontend**: Uses Vite, Hotwire, and TailwindCSS. Entry points in `app/frontend/entrypoints/`.
- **Database**: Main DB is PostgreSQL. Some packs (e.g., Melbourne) use YAML files (see `packs/melbourne/db/data/events.yml`) for event data.

## Developer Workflows
- **Setup**: Run `bin/install-hooks` (once) then `bin/setup` to install dependencies and prepare the DB.
- **Start app**: Use `bin/dev` (runs Vite, Puma, background jobs).
- **Run tests**: Use `bin/tests` for full suite (RSpec + Rubocop), or `bin/rspec` for RSpec only.
- **Deploy**: Main branch auto-deploys to Heroku.

## Conventions & Patterns
- **City Packs**: Each pack is self-contained with its own MVC structure, routes, specs, and data. Namespacing is automatic — files in `packs/melbourne/app/` are automatically under `Melbourne::`.
- **Routes**: Pack routes are drawn into the main app via `draw(:<city>)` in `config/routes.rb` with subdomain constraints.
- **YAML Data**: For Melbourne, events/talks/speakers are managed in `packs/melbourne/db/data/events.yml`. New events go at the top. See `packs/melbourne/README.md` for required fields.
- **Frontend assets**: Images (e.g., sponsor logos) should be 500x150px, white background (`app/frontend/images/sponsors/`).
- **Contribution**: See `CONTRIBUTING.md` for setup, troubleshooting, and guidelines. Mentoring available via the Mentored Contributions Program.

## Integration Points
- **Slack**: Community support in `#org-web` channel.
- **Heroku**: Automatic deployment from `main` branch.
- **CI**: GitHub Actions (`.github/workflows/ci.yml`).

## Key Files & Directories
- `packs/<city>/package.yml`: Pack definition with `automatic_pack_namespace: true`.
- `packs/<city>/config/initializers/root.rb`: Pack root path and route helpers.
- `packs/<city>/config/routes/<city>.rb`: Pack routes with subdomain constraints.
- `packs/<city>/db/data/events.yml`: Event/talk/speaker data.
- `packs/README.md`: Full documentation of the packs architecture.
- `app/frontend/entrypoints/`: JS entry points for Vite.
- `app/frontend/images/sponsors/`: Sponsor logo assets.
- `CONTRIBUTING.md`: Contribution and setup details.

## Example: Adding a New City Pack
1. Create `packs/<city>/package.yml` with `automatic_pack_namespace: true`.
2. Create the directory structure following `packs/melbourne/` as a template.
3. Create `packs/<city>/config/initializers/root.rb` with the pack's root path and routes module.
4. Create `packs/<city>/config/routes/<city>.rb` with subdomain-constrained routes.
5. Add `draw(:<city>)` to `config/routes.rb`.
6. See `packs/README.md` for full details.

---
For questions or mentoring, join Ruby Australia Slack `#org-web`.

_Last updated: 2026-03-08_
