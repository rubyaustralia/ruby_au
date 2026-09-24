# == Schema Information
#
# Table name: talks
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  speakers    :string
#  title       :string           not null
#  video_url   :string           default("unknown"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint           not null
#
# Indexes
#
#  index_talks_on_event_id  (event_id)
#
class Talk < ApplicationRecord
  belongs_to :event, class_name: "DatabaseEvent"

  validates :description, presence: true
  validates :event_id, presence: true
  validates :title, presence: true
  validates :video_url, presence: true

  def youtube_video_id
    return if video_url.blank? || %w[TODO unknown].include?(video_url)

    # Get the 'v' url param of a youtube video url (which is like a youtube vid id) to
    # be used in embedding the youtube video in an iframe
    uri = URI.parse(video_url)
    query_params = Rack::Utils.parse_query(uri.query)
    query_params["v"]
  end
end
