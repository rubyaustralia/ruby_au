# Contributing to Ruby Australia

Thank you for your interest in contributing to Ruby Australia! This project welcomes contributors of all experience levels, from those learning to code to seasoned Ruby veterans.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Project Architecture](#project-architecture)
- [Making Changes](#making-changes)
- [Submitting Your Contribution](#submitting-your-contribution)
- [Getting Help](#getting-help)

---

## Getting Started

### Prerequisites

Before you begin, make sure you have:

- **Git** installed on your machine
- **Ruby** - Check the required version in the [`.tool-versions`](.tool-versions) file (verify with `ruby -v`)
- **Node.js and Yarn** for frontend assets - Check the required version in the [`.tool-versions`](.tool-versions) file (verify with `node -v` and `yarn -v`)
- **PostgreSQL** for the database
- A **GitHub account**
- Joined the [Ruby Australia Slack](https://ruby.org.au/slack) (recommended)

### First-Time Setup

1. **Fork and clone the repository**
   Fork the repository on [GitHub](https://github.com/rubyaustralia/ruby_au/fork)

   ```bash
   git clone https://github.com/YOUR-USERNAME/ruby_au.git
   cd ruby_au
   ```

2. **Install git hooks** (before running setup)

   ```bash
   bin/install-hooks
   ```

3. **Run the setup script**

   ```bash
   bin/setup
   ```

   This will install dependencies, set up the database, and start the development server.

4. **Verify everything works**
   - Visit `http://localhost:3000` in your browser
   - You should see the Ruby Australia homepage

### Running the Development Server

```bash
bin/dev
```

This starts Foreman with Vite (frontend assets), Puma (Rails server), and background jobs.

---

## Development Workflow

### Finding Something to Work On

- Browse the [GitHub Issues](https://github.com/rubyaustralia/ruby_au/issues)
- Look for issues tagged `beginner friendly` if you're new to the project
- Check the [Mentored Contributions Program](https://ruby.org.au/mentored_contributions) for guided tasks
- Ask in the `#org-web` or `#mentored-contributions` Slack channel if you're unsure

### Before You Start Coding

1. **Check if someone else is already working on it** - Comment on the issue to let others know you're taking it
2. **Create a new branch** from `main`
   ```bash
   git checkout main
   git pull origin main
   git checkout -b your-feature-name
   ```

### Code Quality Standards

We use automated tools to maintain code quality:

- **Ruby linting**: `bundle exec rubocop`
- **JavaScript/TypeScript linting**: `yarn lint`

Please run these before submitting your PR. The git hooks will help catch issues early.

### Testing

**Always run tests before submitting a PR:**

```bash
# Run full test suite (RSpec + Rubocop for main app and meetup sites)
bin/tests

# Run only RSpec tests
bin/rspec

# Run tests for city site engines only
bin/rspec sites

# Run a specific test file
bundle exec rspec spec/path/to/specific_spec.rb
```

All tests should pass before you submit your pull request.

---

## Project Architecture

### Multi-Site Engine Pattern

This Rails application uses a "lean engines" pattern to manage multiple Ruby community sites:

- **Main App**: Core Ruby Australia website (`ruby.org.au`)
- **Site Engines**: City-specific sites in the `sites/` directory
  - Example: `melbourne.ruby.org.au` → `sites/melbourne/`

Each site engine is a minimal Rails::Engine with:

- Its own namespace (e.g., `Melbourne::`)
- Its own routes in `sites/[city]/config/routes.rb`
- Its own MVC structure in `sites/[city]/app/`
- Engine definition in `sites/[city]/lib/[city]/engine.rb`

Engines are mounted with subdomain constraints in the main app's `config/routes.rb`.

### Technology Stack

- **Backend**: Ruby on Rails
- **Frontend**: Vite + Hotwire + TailwindCSS
- **Database**: PostgreSQL
- **Background Jobs**: Solid Queue
- **Authentication**: Devise
- **Testing**: RSpec + Capybara + FactoryBot

---

## Making Changes

### Code Style

- Follow Ruby community standards (enforced by Rubocop)
- Write clear, descriptive variable and method names
- Add comments for complex logic, but prefer self-documenting code
- Keep methods small and focused

### Writing Tests

- Add tests for new features
- Update tests when modifying existing features
- Use FactoryBot for test data
- Follow existing test patterns in the `spec/` directory

### Database Changes

- Generate migrations with `bin/rails generate migration`
- Use `bin/rails db:migrate` to apply changes
- Make sure migrations are reversible
- City site engines can have their own migrations in `sites/[city]/db/migrate/`

### Frontend Changes

- Frontend assets are managed by Vite
- Build assets with `yarn build`
- The dev server (`bin/dev`) includes Vite with hot reloading
- Styles use TailwindCSS utility classes

---

## Submitting Your Contribution

### Bug Reports

**Found a bug?**

1. **Check if it's already reported** in [GitHub Issues](https://github.com/rubyaustralia/ruby_au/issues)
2. If not, [open a new issue](https://github.com/rubyaustralia/ruby_au/issues/new) with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Your environment (OS, Ruby version, browser)

### Pull Requests

**Ready to submit your changes?**

1. **Make sure your code is ready**

   - [ ] All tests and linting passes (`bin/tests`)
   - [ ] You've tested manually in the browser

2. **Commit your changes**

   - Write clear, descriptive commit messages
   - The subject line should:
     - Be limited to 50 characters
     - Have a capitalized first letter
     - Not end with a full stop
     - Use the imperative mood (e.g., "Fix bug," "Add feature," not "Fixed bug" or "Adds feature"). This makes the commit message read as a command or instruction.
   - The body should:
     - Wrap at 72 characters
     - Explain the "what" and "why" of the changes, not necessarily the "how."
     - Provide context that might not be immediately obvious from the code changes themselves.
   - Make each commit a single, logical unit of work. Avoid combining unrelated changes into one commit, as this complicates tracking, reviewing, and reverting.

3. **Push to your fork**

   ```bash
   git push origin your-feature-name
   ```

4. **Create a Pull Request**

   - Go to the [Ruby Australia repository](https://github.com/rubyaustralia/ruby_au)
   - Click "New Pull Request"
   - Choose your fork and branch
   - Fill in the PR template with:
     - **What** you changed
     - **Why** you changed it
     - Link to the related issue
     - Screenshots (for UI changes)
     - Any special testing notes

5. **Respond to feedback**
   - Maintainers may request changes
   - Push new commits to the same branch to update your PR
   - Be patient and respectful in discussions

---

## Getting Help

### Stuck or Have Questions?

- **Slack**: Join [Ruby Australia Slack](https://ruby.org.au/slack)
  - `#org-web` - General discussion
  - `#mentored-contributions` - For the Mentored Contributions Program
- **GitHub Issues**: Comment on the issue you're working on

### Mentored Contributions Program

If you're new to open source or want structured support:

- Learn more at [ruby.org.au/pages/mentored_contributions](https://ruby.org.au/pages/mentored_contributions)
- Register for mentoring support
- Get matched with an experienced Rubyist who can guide you

### Code of Conduct

All contributors must follow the [Ruby Australia Code of Conduct](https://ruby.org.au/pages/policies/code-of-conduct). We're committed to providing a welcoming and inclusive environment for everyone.

---

## Thank You!

Ruby Australia is entirely volunteer-run. Every contribution—big or small—helps us support events, tools, and community spaces that bring Rubyists together across Australia.

We're glad you're here. Let's build something great together!

**Ruby Australia**
