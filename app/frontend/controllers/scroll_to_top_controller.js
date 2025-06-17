
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.toggleButtonVisibility()
    window.addEventListener('scroll', this.toggleButtonVisibility.bind(this))
  }

  disconnect() {
    window.removeEventListener('scroll', this.toggleButtonVisibility.bind(this))
  }

  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }

  toggleButtonVisibility() {
    if (document.documentElement.scrollTop > 300) { // Show button when page is scrolled down 300px or more
      this.buttonTarget.classList.remove('hidden')
      this.buttonTarget.classList.add('flex')
    } else {
      this.buttonTarget.classList.add('hidden')
      this.buttonTarget.classList.remove('flex')
    }
  }
}
