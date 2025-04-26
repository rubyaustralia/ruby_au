import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "overlay"]

  connect() {
    document.addEventListener("click", this.closeMenuOnClickOutside)
    document.addEventListener("keydown", this.handleKeyDown)
  }

  disconnect() {
    document.removeEventListener("click", this.closeMenuOnClickOutside)
    document.removeEventListener("keydown", this.handleKeyDown)
  }

  toggle() {
    if (this.isMenuOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.overlayTarget.classList.remove("hidden")
    setTimeout(() => {
      this.overlayTarget.classList.add("opacity-100")
    }, 10)
    this.menuTarget.style.right = "0"
    document.body.classList.add("overflow-hidden")
    this.isMenuOpen = true
  }

  close() {
    this.overlayTarget.classList.remove("opacity-100")
    this.menuTarget.style.right = "-100%"

    setTimeout(() => {
      this.overlayTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }, 300)

    this.isMenuOpen = false
  }

  closeMenuOnClickOutside = (event) => {
    if (this.isMenuOpen && !this.menuTarget.contains(event.target) &&
      !event.target.closest('[data-action="slideout-menu#toggle"]')) {
      this.close()
    }
  }

  handleKeyDown = (event) => {
    if (this.isMenuOpen && event.key === "Escape") {
      this.close()
    }
  }

  get isMenuOpen() {
    return this.data.get("open") === "true"
  }

  set isMenuOpen(value) {
    this.data.set("open", value)
  }
}
