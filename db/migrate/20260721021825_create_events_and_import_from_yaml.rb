DATABASE_EVENT_DEFAULTS = {
  region: 'melbourne',
  start_time: '6:30pm',
  end_time: '8:30pm'
}.freeze

class CreateEventsAndImportFromYaml < ActiveRecord::Migration[8.1]
  def change

    create_table :venues do |t|
      t.string :name, null: false
      t.string :google_maps_url, null: false
      t.string :address, null: false
      t.text :notes
      t.timestamps
    end

    create_table :events do |t|
      t.date :date, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.string :name, null: false
      t.text :description, null: false
      t.string :slug, null: false
      t.string :event_type, null: false
      t.string :region, null: false
      t.references :venue
      t.string :registration_url
      t.timestamps
    end

    create_table :talks do |t|
      t.references :event, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :speakers
      t.string :video_url, default: "unknown", null: false
      t.timestamps
    end

    change_table :users do |t|
      t.boolean :meetup_admin, default: false, null: false
    end

    reversible do |direction|
      direction.up do
        import_yaml_events
        set_seeds_meetup_admin
      end
    end
  end

  private

  def format_address(address)
    "#{address.street} #{address.locality} #{address.postal_code} #{address.region} #{address.country}"
  end

  def build_db_venue(event)
    Venue.find_or_create_by!(
      **event.venue.slice(:name, :google_maps_url),
      address: format_address(event.venue.address)
    )
  end

  def build_db_talks(event, db_event)
    event.talks&.each do |talk|
      db_talk = Talk.find_or_create_by!(
        **talk.slice(:title, :description, :video_url),
        event: db_event,
        speakers: talk.speakers.map(&:name).join
      )
      db_talk.save
    end
  end

  def build_db_event(event)
    DatabaseEvent.new(
      **event.slice(:date, :description, :name, :slug),
      event_type: event.type,
      registration_url: event.registration_link,
      venue: build_db_venue(event),
      **DATABASE_EVENT_DEFAULTS
    )
  end

  def import_yaml_events
    Melbourne::Event.all.each do |event| # rubocop:disable Rails/FindEach
      if DatabaseEvent.find_by(name: event.name)
        Rails.logger.info "Event #{event.name} already exists - skipped"
      else
        db_event = build_db_event(event)
        if db_event.save
          build_db_talks(event, db_event)
          Rails.logger.info "Imported Event: #{event.name}"
        else
          Rails.logger.error "Failed to import event #{event.name}: #{db_event.errors.full_messages.to_sentence}"
        end
      end
    end

    def set_seeds_meetup_admin
      if (user = User.find_by_email("meetup_admin@example.com"))
        user.meetup_admin = true
        if user.save
          Rails.logger.info "Set user #{user.email} to have meetup_admin rights"
        else
          Rails.logger.error "Failed to update user #{user.email} to have meetup_admin rights: #{user.errors.full_messages.to_sentence}"
        end
      end
    end
  end
end
