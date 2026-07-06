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
require 'rails_helper'

RSpec.describe Talk, type: :model do
  describe "#youtube_video_id" do
    context "when video_url value is either nil, 'TODO' or 'unknown'" do
      it "returns nil" do
        talk = described_class.new(video_url: "unknown")
        expect(talk.youtube_video_id).to be_nil

        talk.video_url = "TODO"
        expect(talk.youtube_video_id).to be_nil

        talk.video_url = nil
        expect(talk.youtube_video_id).to be_nil
      end
    end

    context "when video_url does not have have 'v' url param" do
      it "returns nil" do
        talk = described_class.new(video_url: "https://www.youtube.com/watch")

        expect(talk.youtube_video_id).to be_nil
      end
    end

    context "when video_url have 'v' url param" do
      it "returns the value of the 'v' url param" do
        talk = described_class.new(video_url: "https://www.youtube.com/watch?v=12345abcd6")

        expect(talk.youtube_video_id).to eq("12345abcd6")
      end
    end
  end
end
