# frozen_string_literal: true

require "rails_helper"

feature "Admin Event Management" do
  let(:admin) { FactoryBot.create(:user, committee: true) }

  before do
    Membership.find_or_create_by!(user: admin) { |m| m.joined_at = Time.current }
    log_in_as admin
  end

  # datetime_select renders month as a name ("January") while its value is "1",
  # so we can't select by visible text uniformly. Select each dropdown by value.
  def select_happens_at(year:, month:, day:, hour:, minute:)
    {
      "1i" => year, "2i" => month, "3i" => day, "4i" => hour, "5i" => minute
    }.each do |suffix, value|
      find("#rsvp_event_happens_at_#{suffix} option[value='#{value}']").select_option
    end
  end

  def select_time_zone(name)
    find("#rsvp_event_time_zone option[value='#{name}']").select_option
  end

  scenario "Admin creates an event and it is stored as the correct UTC instant" do
    visit new_admin_rsvp_event_path

    fill_in "Title", with: "Perth Ruby Meetup"

    select_happens_at(year: "2026", month: "11", day: "1", hour: "10", minute: "00")
    select_time_zone "Perth"

    click_button "Submit"

    expect(page).to have_content("Event created")
    expect(page).to have_content("01 Nov 2026, 02:00 UTC")
  end

  scenario "Admin edits an event, bumping it one hour, and the new UTC instant is shown" do
    # Perth 10:00 == 02:00 UTC. Bumping to Perth 11:00 must land on 03:00 UTC.
    event = FactoryBot.create(:rsvp_event,
                              title: "Perth Ruby Meetup",
                              happens_at: Time.utc(2026, 11, 1, 2, 0))

    visit edit_admin_rsvp_event_path(event)

    select_happens_at(year: "2026", month: "11", day: "1", hour: "11", minute: "00")
    select_time_zone "Perth"

    click_button "Submit"

    expect(page).to have_content("Event updated")
    expect(page).to have_content("01 Nov 2026, 03:00 UTC")
  end
end
