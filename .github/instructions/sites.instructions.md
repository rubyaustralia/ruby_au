---
applyTo: "sites/**"
description: "Conventions for the Ruby Australia meetup sites"
---

# Site engine namespacing

The meetup sites under `sites/` are Rails Engines with a custom Zeitwerk configuration in `config/initializers/sites.rb`. This configuration removes the requirement that the site name appear as a directory segment in the file path for namespacing purposes.

**Files under `sites/<site>/app/**` are namespaced under the site's module without a matching directory.**

For example, the Melbourne site's events controller:

- Constant: `Melbourne::EventsController`
- File path: `sites/melbourne/app/controllers/events_controller.rb`
- **Not**: `sites/melbourne/app/controllers/melbourne/events_controller.rb`

The same applies to models, helpers, jobs, mailers, and any other autoloaded `app/` subdirectory within a site.

When reviewing or generating code in `sites/`, do not flag the absence of the site-name directory as a Zeitwerk or Rails autoloading violation, and do not suggest moving files into a site-named subdirectory. The custom initializer makes the shorter path correct.
