require "rails_helper"

RSpec.describe(Melbourne::Event::Talk, type: :model) do
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

    context "when video_url is a supported YouTube URL format" do
      {
        "https://youtu.be/nKgcnSwq6Jc?si=liAXndBaxFhO0NwE" => "nKgcnSwq6Jc",
        "https://youtu.be/nKgcnSwq6Jc" => "nKgcnSwq6Jc",
        "https://www.youtube.com/watch?v=nKgcnSwq6Jc&t=42s" => "nKgcnSwq6Jc",
        "https://m.youtube.com/watch?v=nKgcnSwq6Jc" => "nKgcnSwq6Jc",
        "https://www.youtube.com/embed/nKgcnSwq6Jc" => "nKgcnSwq6Jc",
        "https://www.youtube-nocookie.com/embed/nKgcnSwq6Jc" => "nKgcnSwq6Jc",
        "https://www.youtube.com/shorts/nKgcnSwq6Jc" => "nKgcnSwq6Jc",
        "https://www.youtube.com/live/nKgcnSwq6Jc?si=abc" => "nKgcnSwq6Jc"
      }.each do |url, expected_id|
        it "extracts the video ID from #{url}" do
          talk = described_class.new(video_url: url)

          expect(talk.youtube_video_id).to eq(expected_id)
        end
      end
    end

    context "when video_url is not a YouTube video URL" do
      [
        "https://vimeo.com/123456",
        "https://example.com/watch?v=nKgcnSwq6Jc",
        "https://www.youtube.com/channel/UC123",
        "https://youtu.be/",
        "not a url at all"
      ].each do |url|
        it "returns nil for #{url}" do
          talk = described_class.new(video_url: url)

          expect(talk.youtube_video_id).to be_nil
        end
      end
    end
  end
end
