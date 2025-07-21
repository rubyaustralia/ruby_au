import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["item"];

  setAriaCurrent(event) {
    this.itemTargets.forEach((element) => element.removeAttribute("aria-current"))
    event.currentTarget.setAttribute("aria-current", "page")
  }
}
