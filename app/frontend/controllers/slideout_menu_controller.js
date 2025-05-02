import { Controller } from "@hotwired/stimulus"
import { createIcons, icons } from 'lucide';

export default class extends Controller {
  static targets = ["menu", "overlay"]
  static values = { open: Boolean }

  ignoreNextClick = false

  connect() {
    this.openValue = false
    document.addEventListener("click", this.closeMenuOnClickOutside, { capture: true })
    document.addEventListener("keydown", this.handleKeyDown)
  }

  disconnect() {
    document.removeEventListener("click", this.closeMenuOnClickOutside, { capture: true })
    document.removeEventListener("keydown", this.handleKeyDown)
  }

  toggle(event) {
    this.ignoreNextClick = true

    setTimeout(() => {
      this.ignoreNextClick = false
    }, 0)

    if (this.openValue) {
      this.close()
    } else {
      this.open()
    }

    if (event) {
      event.stopPropagation()
    }
  }

  open() {
    this.overlayTarget.classList.remove("hidden")
    setTimeout(() => {
      this.overlayTarget.classList.add("opacity-100")
    }, 10)
    this.menuTarget.style.right = "0"
    document.body.classList.add("overflow-hidden")
    this.openValue = true

    createIcons({
      icons,
      attrs: {
        class: "",
        stroke: "currentColor"
      },
      elements: this.menuTarget.querySelectorAll('[data-lucide]')
    });
  }

  close() {
    this.overlayTarget.classList.remove("opacity-100")
    this.menuTarget.style.right = "-100%"

    setTimeout(() => {
      this.overlayTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }, 300)

    this.openValue = false
  }

  closeMenuOnClickOutside = (event) => {
    if (this.ignoreNextClick) return

    if (this.openValue &&
      !this.menuTarget.contains(event.target) &&
      !event.target.closest('[data-action="slideout-menu#toggle"]')) {
      this.close()
    }
  }

  handleKeyDown = (event) => {
    if (this.openValue && event.key === "Escape") {
      this.close()
    }
  }
}
