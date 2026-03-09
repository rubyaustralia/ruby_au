# Sites Directory

This directory holds the code for websites under the `ruby.org.au` domain. Each subdirectory powers a specific subdomain of the main Ruby Australia website, with automatic namespace isolation via Zeitwerk.

## Architecture

Each site is a self-contained module with its own MVC structure, routes, specs, and data. Zeitwerk automatically wraps all code in a namespace matching the directory name (e.g., `sites/melbourne/` → `Melbourne::`). This is configured in `config/initializers/sites.rb`.

### Current Sites

- **melbourne/** — Powers `melbourne.ruby.org.au` — Ruby Melbourne meetup community site

## How It Works

### 1. Site Initializer (`sites/<city>/config/initializers/root.rb`)

Provides the site's root path and route URL helpers:

```ruby
module Melbourne
  def self.root
    @root ||= Rails.root.join("sites/melbourne")
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

### 2. Routes (`sites/<city>/config/routes/<city>.rb`)

Site routes are drawn into the main application via `draw(:city)` in `config/routes.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  draw(:melbourne)
  # ...
end
```

Each site defines its routes with subdomain constraints:

```ruby
# sites/melbourne/config/routes/melbourne.rb
Rails.application.routes.draw do
  constraints subdomain: "melbourne" do
    scope module: "melbourne", as: "melbourne" do
      get "/", to: "home#show", as: :home
      resources :events, only: %i[index show], param: :slug
    end
  end
end
```

### 3. Site Structure

```
sites/<city>/
├── app/
│   ├── controllers/               # Auto-namespaced (e.g., Melbourne::EventsController)
│   ├── models/                    # Auto-namespaced (e.g., Melbourne::Event)
│   ├── presenters/                # Auto-namespaced (e.g., Melbourne::EventPresenter)
│   └── views/
│       ├── layouts/<city>/        # City-specific layouts
│       └── <city>/                # City-namespaced view templates
├── config/
│   ├── initializers/root.rb       # Site root path and route helpers
│   └── routes/<city>.rb           # Site routes
├── db/data/                       # YAML data files
├── lib/                           # Data processing, utilities
├── spec/                          # Site-specific specs
└── .rubocop.yml                   # Inherits from root
```

### 4. RSpec Integration

The `.rspec` file includes `--require sites_rspec` which enables automatic discovery of specs inside sites.

## Adding a New Site

1. Create the directory structure following `sites/melbourne/` as a template
2. Create `sites/<city>/config/initializers/root.rb` with the site's root path and routes module
3. Create `sites/<city>/config/routes/<city>.rb` with subdomain-constrained routes
4. Add `draw(:<city>)` to `config/routes.rb`

For detailed implementation, refer to the Melbourne site as an example.
