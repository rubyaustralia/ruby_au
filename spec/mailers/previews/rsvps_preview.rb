class RsvpsPreview < ActionMailer::Preview
  def announcement
    RsvpsMailer.announcement Rsvp.first
  end
end
