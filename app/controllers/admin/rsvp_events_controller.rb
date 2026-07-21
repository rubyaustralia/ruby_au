class Admin::RsvpEventsController < Admin::ApplicationController
  before_action :set_rsvp_event, only: %i[edit update]

  def index
    @events = RsvpEvent.order(happens_at: :desc).page(params[:page])
  end

  def new
    @event = RsvpEvent.new
  end

  def create
    tz = ActiveSupport::TimeZone[rsvp_event_params[:time_zone]]

    if tz.nil?
      @event = RsvpEvent.new(rsvp_event_params.except(:time_zone))
      @event.errors.add(:time_zone, "is not a valid time zone")
      return render :new, status: :unprocessable_entity
    end

    @event = Time.use_zone(tz) do
      RsvpEvent.new(rsvp_event_params.except(:time_zone))
    end

    if @event.save
      redirect_to admin_rsvp_event_path(@event), notice: "Event created"
    else
      render :new, status: :unprocessable_entity
    end
  rescue ArgumentError
    @event ||= Time.use_zone(tz || Time.zone) do
      RsvpEvent.new(rsvp_event_params.except(:time_zone))
    end
    @event.errors.add(:happens_at, "is not a valid date/time")
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
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
