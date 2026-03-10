# Ruby Melbourne

The Ruby Melbourne community site is a subdirectory application that manages events, talks, and speakers for the Ruby Melbourne meetup.

## Database

The application's data is stored in [`db/data/events.yml`](db/data/events.yml). This YAML file contains all event information including venues, talks, and speaker details.

### Adding New Events

To add a new event, add a new entry **at the top** of [`db/data/events.yml`](db/data/events.yml) with all required data fields. The required fields are defined by the model validations:

### Required Event Fields
- `uuid` - Unique identifier for the event
- `date` - Event date (YYYY-MM-DD format)
- `name` - Event title
- `description` - Event description
- `slug` - URL-friendly identifier (YYYY-MM-DD-event-name format)
- `type` - Event type (typically "meetup")
- `venue` - Venue information (see venue requirements below)
- `talks` - Array of talks (see talk requirements below)

### Optional Event Fields
- `registration_link` - Link to event registration

### Required Venue Fields
- `name` - Venue name
- `google_maps_url` - Google Maps link to venue
- `address` - Address object with street, locality, postal_code, region, country

### Required Talk Fields
- `uuid` - Unique identifier for the talk
- `title` - Talk title
- `description` - Talk description
- `video_url` - Video URL (use "TODO" if not yet available)
- `speakers` - Array of speakers (see speaker requirements below)

### Required Speaker Fields
- `name` - Speaker name
- `contact_details` - Object with optional fields: github_username, x_handle, linkedin_handle, bluesky_handle, mastodon_handle, website

## Architecture

The models in this application are **ActiveModel objects** (not ActiveRecord) that pull their data from the [`events.yml`](db/data/events.yml) file. The main models are:

- [`Melbourne::Event`](app/models/melbourne/event.rb) - Main event model
- [`Melbourne::Event::Venue`](app/models/melbourne/event/venue.rb) - Venue information
- [`Melbourne::Event::Talk`](app/models/melbourne/event/talk.rb) - Individual talks
- [`Melbourne::Event::Speaker`](app/models/melbourne/event/speaker.rb) - Speaker information

## Assets

Assets are handled by the main application at [`app/frontend`](../../app/frontend). The Melbourne site uses a separate stylesheet that is independent of the main application's styling.

## Development

### Setup and Running

1. Run the standard setup: `bin/setup`
2. Start the development server: `bin/dev`
3. Access the Melbourne site at: `melbourne.localhost:3000`

### Browser Compatibility

**Note:** Safari does not work with the local subdomain setup. Use **Chrome** or **Firefox** for development.
