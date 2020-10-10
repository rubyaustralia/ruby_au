# frozen_string_literal: true

class AddLinkToRsvpEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :rsvp_events, :link, :string
  end
end
