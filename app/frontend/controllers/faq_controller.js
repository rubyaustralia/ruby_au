import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  toggle(event) {
    const item = event.currentTarget
    const answer = item.nextElementSibling
    const icon = item.querySelector('.angle-down')

    answer.classList.toggle('hidden')
    icon.classList.toggle('rotate-180')
  }
}
