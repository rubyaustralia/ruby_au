import { Controller } from "@hotwired/stimulus"
import { createIcons, icons } from 'lucide';

export default class extends Controller {
  static targets = ["menu", "overlay"]
  static values = { open: Boolean }

  #menuToggleInProgress = false

  connect() {
    this.openValue = false
    document.addEventListener("click", this.handleOutsideClick, { capture: true })
    document.addEventListener("keydown", this.handleEscapeKey)
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick, { capture: true })
    document.removeEventListener("keydown", this.handleEscapeKey)
  }

  toggle(event) {
    if (this.#menuToggleInProgress) return
    this.#menuToggleInProgress = true

    this.openValue ? this.close() : this.open()

    if (event) event.stopPropagation()

    setTimeout(() => this.#menuToggleInProgress = false, 0)
  }

  open() {
    this.overlayTarget.classList.remove("hidden")
    requestAnimationFrame(() => {
      this.overlayTarget.classList.add("opacity-100")
      this.menuTarget.style.right = "0"
      document.body.classList.add("overflow-hidden")
      this.openValue = true

      createIcons({
        icons,
        attrs: { stroke: "currentColor" },
        elements: this.menuTarget.querySelectorAll('[data-lucide]')
      });
    })
  }

  close() {
    this.overlayTarget.classList.remove("opacity-100")
    this.menuTarget.style.right = "-100%"
    this.openValue = false

    setTimeout(() => {
      if (!this.openValue) {
        this.overlayTarget.classList.add("hidden")
        document.body.classList.remove("overflow-hidden")
      }
    }, 300)
  }

  handleOutsideClick = (event) => {
    if (this.#menuToggleInProgress) return

    if (this.openValue &&
      !this.menuTarget.contains(event.target) &&
      !event.target.closest('[data-action="slideout-menu#toggle"]')) {
      this.close()
    }
  }

  handleEscapeKey = (event) => {
    if (this.openValue && event.key === "Escape") {
      this.close()
    }
  }
}
