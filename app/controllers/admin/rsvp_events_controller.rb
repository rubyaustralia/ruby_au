class Admin::RsvpEventsController < Admin::ApplicationController
  before_action :set_rsvp_event, only: %i[edit update]

  def index
    @events = RsvpEvent.order(happens_at: :desc).page(params[:page])
  end

  def new
    @event = RsvpEvent.new
  end

  def create
    @event = RsvpEvent.new(rsvp_event_params)

    if @event.save
      redirect_to admin_rsvp_events_path, notice: "Event created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(rsvp_event_params)
      redirect_to admin_rsvp_events_path, notice: "Event updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_rsvp_event
    @event = RsvpEvent.find(params.expect(:id))
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_rsvp_events_path, alert: 'Event not found'
  end

  def rsvp_event_params
    params.require(:rsvp_event).permit(
      :title,
      :time_zone,
      :"happens_at(1i)", # year
      :"happens_at(2i)", # month
      :"happens_at(3i)", # day
      :"happens_at(4i)", # hour
      :"happens_at(5i)"  # minute
    )
  end
end
