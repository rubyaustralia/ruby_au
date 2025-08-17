module VideosHelper
  def youtube_iframe(video_id)
    content_tag(:iframe, "",
                src: "https://www.youtube.com/embed/#{video_id}",
                class: "w-full h-full",
                frameborder: "0",
                allowfullscreen: true)
  end
end
