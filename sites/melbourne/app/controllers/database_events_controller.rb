# frozen_string_literal: true

module Melbourne
  class DatabaseEventsController < ApplicationController
    before_action :set_database_event, only: %i[show edit update destroy]

    def index
      @database_events = DatabaseEvent.all_by_date
    end

    def new
      @database_event = DatabaseEvent.new
    end

    def edit; end

    def create
      @database_event = DatabaseEvent.new(database_event_params)

      if @database_event.save
        redirect_to melbourne_database_event_path(@database_event), notice: "Event was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @database_event.update(database_event_params)
        redirect_to melbourne_database_event_path(@database_event), notice: "Event was successfully updated."
      else
        render :edit, status: :unprocessable_content, alert: "Event could not be updated due to #{@database_event.errors.full_messages.to_sentence}."
      end
    end

    def destroy
      if @database_event.destroy
        redirect_to melbourne_database_events_path, notice: "Event was successfully deleted."
      else
        flash[:alert] = "Event could not be deleted due to #{@database_event.errors.full_messages.to_sentence}."
        redirect_back fallback_location: melbourne_database_events_path
      end
    end

    def show
      @event_presenter = EventPresenter.new(@database_event)
    end

    private

    def set_database_event
      @database_event = DatabaseEvent.find_by!(slug: params[:slug])
    rescue ActiveRecord::RecordNotFound
      redirect_to melbourne_database_events_path, alert: "Event '#{params[:slug]}' is not found"
    end

    def database_event_params
      params.expect(database_event: [:date, :description, :event_type, :name, :region, :registration_url, :start_time, :end_time, :venue_id])
    end
  end
end
