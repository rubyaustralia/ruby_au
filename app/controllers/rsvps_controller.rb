class RsvpsController < ApplicationController
  expose(:rsvp) { Rsvp.find_by token: params[:id] }

  def confirm
    rsvp.update status: 'yes'

    redirect_to rsvp_path(rsvp.token), notice: "Thanks for confirming your attendance to #{rsvp.rsvp_event.title}."
  end

  def decline
    rsvp.update status: 'no'

    redirect_to rsvp_path(rsvp.token), notice: "We're sorry you can't make it to #{rsvp.rsvp_event.title}, but thanks for letting us know."
  end
end
