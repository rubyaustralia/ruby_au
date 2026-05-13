require "rails_helper"

RSpec.describe Melbourne::DatabaseEventsController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe 'GET /database_events' do
    let!(:past_event) { FactoryBot.create(:database_event, :meetup, :melbourne, date: 1.month.ago) }
    let!(:current_event) { FactoryBot.create(:database_event, :meetup, :melbourne, date: 1.day.from_now) }

    it 'displays events in correct order' do
      get melbourne_database_events_path
      expect(response).to have_http_status(:ok)

      database_events = assigns(:database_events)
      expect(database_events.to_a).to eq([current_event, past_event])
    end
  end

  describe "show" do
    let(:database_event) { FactoryBot.create(:database_event, :meetup, :melbourne, slug: "test-slug") }

    it "displays the event page" do
      allow(DatabaseEvent).to receive(:find_by!).and_return(database_event)

      get melbourne_database_event_path("test-slug")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(database_event.name)
    end

    it 'redirects to index when event not found' do
      get melbourne_database_event_path('non-existent')
      expect(response).to redirect_to(melbourne_database_events_path)
    end
  end

  describe 'GET /database_events/new' do
    it 'initializes a new event' do
      get new_melbourne_database_event_path
      expect(response).to have_http_status(:ok)
      expect(assigns(:database_event)).to be_a_new(DatabaseEvent)
    end
  end

  describe 'GET /database_events/:id/edit' do
    let(:database_event) { FactoryBot.create(:database_event, :meetup, :melbourne) }

    it 'shows edit form' do
      get edit_melbourne_database_event_path(database_event)
      expect(response).to have_http_status(:ok)
      expect(assigns(:database_event)).to eq(database_event)
    end
  end

  describe 'POST /database_events' do
    let(:venue) { FactoryBot.create(:venue) }
    let(:database_event_attributes) do
      { date: 1.month.from_now, description: 'description', slug: 'event-slug',
        name: 'name', start_time: 1.month.from_now, venue_id: venue.id, event_type: :meetup, region: :melbourne }
    end

    context 'with valid parameters' do
      it 'creates a new event' do
        expect do
          post melbourne_database_events_path, params: { database_event: database_event_attributes }
        end.to change(DatabaseEvent, :count).by(1)

        expect(response).to redirect_to(melbourne_database_event_path(DatabaseEvent.last))
        expect(flash[:notice]).to eq('Event was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { database_event_attributes.merge(name: '') }

      it 'does not create an event' do
        expect do
          post melbourne_database_events_path, params: { database_event: invalid_attributes }
        end.not_to change(DatabaseEvent, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /database_events/:id' do
    let(:database_event) { FactoryBot.create(:database_event, :meetup, :melbourne) }
    let(:new_attributes) { { name: 'Updated Name' } }

    context 'with valid parameters' do
      it 'updates the event' do
        patch melbourne_database_event_path(database_event), params: { database_event: new_attributes }

        database_event.reload
        expect(database_event.name).to eq('Updated Name')
        expect(response).to redirect_to(melbourne_database_event_path(database_event))
        expect(flash[:notice]).to eq('Event was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '' } }

      it 'does not update the event' do
        original_name = database_event.name
        patch melbourne_database_event_path(database_event), params: { database_event: invalid_attributes }

        database_event.reload
        expect(database_event.name).to eq(original_name)
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /database_events/:id' do
    let(:database_event) { FactoryBot.create(:database_event, :meetup, :melbourne) }

    it 'deletes the event' do
      delete melbourne_database_event_path(database_event)
      expect(response).to redirect_to(melbourne_database_events_path)
      expect(flash[:notice]).to eq('Event was successfully deleted.')
      expect(DatabaseEvent.find_by(id: database_event.id)).to be_nil
    end
  end
end
