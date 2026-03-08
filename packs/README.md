# Packs Directory

This directory holds the code for websites under the `ruby.org.au` domain. Each subdirectory is a [packs-rails](https://github.com/rubyatscale/packs-rails) pack with [automatic_namespaces](https://github.com/rubyatscale/automatic_namespaces), powering a specific subdomain of the main Ruby Australia website.

## Architecture

Each pack is a self-contained module with its own MVC structure, routes, specs, and data. The `automatic_namespaces` gem automatically wraps all code in a namespace matching the pack directory name (e.g., `packs/melbourne/` → `Melbourne::`).

### Current Packs

- **melbourne/** — Powers `melbourne.ruby.org.au` — Ruby Melbourne meetup community site

## How It Works

### 1. Pack Definition (`packs/<city>/package.yml`)

Each pack declares automatic namespacing:

```yaml
metadata:
  automatic_pack_namespace: true
```

### 2. Pack Initializer (`packs/<city>/config/initializers/root.rb`)

Provides the pack's root path and route URL helpers:

```ruby
module Melbourne
  def self.root
    @root ||= Packs.find("packs/melbourne").path
  end

  module Routes
    DEFAULT_URL_OPTIONS = { host: "localhost", port: 3000 }
                               .merge(Rails.application.routes.default_url_options)
                               .merge(subdomain: "melbourne")
                               .freeze

    def self.url_helpers = Rails.application.routes.url_helpers
  end
end
```

### 3. Routes (`packs/<city>/config/routes/<city>.rb`)

Pack routes are drawn into the main application via `draw(:city)` in `config/routes.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  draw(:melbourne)
  # ...
end
```

Each pack defines its routes with subdomain constraints:

```ruby
# packs/melbourne/config/routes/melbourne.rb
Rails.application.routes.draw do
  constraints subdomain: "melbourne" do
    scope module: "melbourne", as: "melbourne" do
      get "/", to: "home#show", as: :home
      resources :events, only: %i[index show], param: :slug
    end
  end
end
```

### 4. Pack Structure

```
packs/<city>/
├── package.yml                    # Pack definition
├── app/
│   ├── controllers/               # Auto-namespaced (e.g., Melbourne::EventsController)
│   ├── models/                    # Auto-namespaced (e.g., Melbourne::Event)
│   ├── presenters/                # Auto-namespaced (e.g., Melbourne::EventPresenter)
│   └── views/
│       ├── layouts/<city>/        # City-specific layouts
│       └── <city>/                # City-namespaced view templates
├── config/
│   ├── initializers/root.rb       # Pack root path and route helpers
│   └── routes/<city>.rb           # Pack routes
├── db/data/                       # YAML data files
├── lib/                           # Data processing, utilities
├── spec/                          # Pack-specific specs
└── .rubocop.yml                   # Inherits from root
```

### 5. RSpec Integration

The `.rspec` file includes `--require packs/rails/rspec` which enables automatic discovery of specs inside packs.

## Adding a New Pack

1. Create `packs/<city>/package.yml` with `automatic_pack_namespace: true`
2. Create the directory structure following the pattern in `packs/melbourne/`
3. Create `packs/<city>/config/initializers/root.rb` with the pack's root path and routes module
4. Create `packs/<city>/config/routes/<city>.rb` with subdomain-constrained routes
5. Add `draw(:<city>)` to `config/routes.rb`

For detailed implementation, refer to the Melbourne pack as an example.
