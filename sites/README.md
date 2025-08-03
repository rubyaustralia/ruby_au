# Sites Directory

This directory holds the code for websites under the `ruby.org.au` domain. Each subdirectory represents a separate Rails Engine that powers a specific subdomain of the main Ruby Australia website.

## Architecture: Lean Engines

The sites are implemented as "lean engines" following the pattern explained in [this talk by Julian Pinzon](https://www.youtube.com/watch?v=StDoHXO8H6E). Lean engines are a lightweight approach to modularizing Rails applications by creating minimal Rails Engines that contain only the necessary components for their specific functionality.

## Current Sites

- **melbourne/** - Powers `melbourne.ruby.org.au` - Ruby Melbourne meetup community site

## How It Works

### 1. Engine Registration

Each lean engine is required in the main application's [`config/application.rb`](../config/application.rb):

```ruby
# Require engines
require_relative "../sites/melbourne/lib/melbourne"
```

This requires the engine's main entry point file: `sites/<city>/lib/<city>.rb`

### 2. Engine Entry Point (`sites/<city>/lib/<city>.rb`)

This file serves as the main entry point for the engine and is responsible for loading the actual engine class:

```ruby
require_relative "melbourne/engine"

module Melbourne
end
```

**Key Role**: This file is what gets required by the main application and ensures the engine is properly loaded into the Rails application.

### 3. Engine Definition (`sites/<city>/lib/<city>/engine.rb`)

This file contains the actual Rails::Engine class that defines the engine's behavior:

```ruby
module Melbourne
  class Engine < Rails::Engine
    isolate_namespace Melbourne

    root.join("lib").tap do |lib|
      config.autoload_paths << lib.to_s
      config.eager_load_paths << lib.to_s
    end

    routes.default_url_options = { host: "localhost", port: 3000, subdomain: "melbourne" }
  end
end
```

**Key Role**: This is the core engine definition that:
- Inherits from `Rails::Engine` to integrate with Rails
- Isolates the namespace to prevent conflicts with the main app
- Configures autoload and eager load paths
- Sets up engine-specific configuration

**These two files are essential for connecting the engine to the parent Rails app** - without them, the engine cannot be loaded or mounted.

### 4. Engine Mounting

The engines are mounted in the main application's [`config/routes.rb`](../config/routes.rb) using subdomain constraints:

```ruby
constraints subdomain: "melbourne" do
  mount(Melbourne::Engine, at: "/")
end
```

### 5. Engine Structure

Each engine follows a minimal structure:

```
sites/[site_name]/
├── app/
│   ├── controllers/
│   ├── models/
│   └── views/
├── config/
│   └── routes.rb        # Engine-specific routes
├── lib/
│   └── [site_name]/
│       └── engine.rb    # Engine definition
└── [site_name].rb       # Engine loader
```

### 6. Independent Routes

Each engine defines its own routes in `config/routes.rb`. For example, the Melbourne engine:

```ruby
Melbourne::Engine.routes.draw do
  root to: "home#show"
  resources :events, only: %i[index show], param: :slug
end
```

## Benefits of Lean Engines

- **Modular Architecture**: Each site is self-contained with its own controllers, models, and views
- **Independent Development**: Sites can be developed independently
- **Namespace Isolation**: Each engine has its own namespace, preventing conflicts
- **Shared Infrastructure**: All engines benefit from the main app's configuration and gems
- **Subdomain Routing**: Clean URL structure with dedicated subdomains for each community

## Adding a New Site

To add a new site engine:

1. Create the site directory: `sites/[site_name]/`
2. Create the engine structure following the pattern in `sites/melbourne/`
3. Add the engine require to `config/application.rb`
4. Add subdomain routing to `config/routes.rb`
5. Create the engine's routes in `sites/[site_name]/config/routes.rb`

For detailed implementation, refer to the Melbourne engine as an example.
