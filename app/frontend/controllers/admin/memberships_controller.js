import { Controller } from "@hotwired/stimulus"
import { debounce } from "../../utils/debounce"

export default class extends Controller {
  connect() {
    this.debouncedSubmit = debounce((event) => {
      event.target.closest("form").requestSubmit()
    }, 250)
  }

  submitForm(event) {
    this.debouncedSubmit(event)
  }
}
