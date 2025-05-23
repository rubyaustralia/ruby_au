import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.trackPageView()
  }

  trackPageView() {
    if (typeof window.ahoy === 'undefined') {
      this.loadAhoy().then(() => {
        this.track()
      })
    } else {
      this.track()
    }
  }

  track() {
    window.ahoy.trackView()

    window.ahoy.track('Page View', {
      page: window.location.pathname,
      title: document.title,
      referrer: document.referrer
    })
  }

  loadAhoy() {
    return new Promise((resolve) => {
      if (window.ahoy) {
        resolve()
        return
      }

      const script = document.createElement('script')
      script.src = 'https://unpkg.com/ahoy.js@0.4.2/dist/ahoy.js'
      script.onload = () => {
        resolve()
      }
      document.head.appendChild(script)
    })
  }
}