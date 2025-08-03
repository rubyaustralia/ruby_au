import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.playVideo()
  }

  playVideo() {
    // Safari mobile autoplay requires user interaction, but allows it after navigation
    // We use a delayed approach to avoid autoplay issues during page transitions
    const video = this.element

    if (video) {
      // Small delay to avoid Safari mobile navigation conflicts
      setTimeout(() => {
        const playPromise = video.play()

        if (playPromise !== undefined) {
          playPromise.catch(() => {
            // Autoplay prevented, which is fine for background videos
          })
        }
      }, 100)
    }
  }

  disconnect() {
    this.element.pause()
  }
}
