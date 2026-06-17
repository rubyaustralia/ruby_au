import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hiddenInput"]
  static values = { url: String }

  connect() {
    this.resultsTarget.classList.add("hidden")
    this.selectedIndex = -1
  }

  onInput() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.hideResults()
      return
    }

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.fetchResults(query)
    }, 300)
  }

  async fetchResults(query) {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
    const users = await response.json()
    this.renderResults(users)
  }

  renderResults(users) {
    if (users.length === 0) {
      this.hideResults()
      return
    }

    this.resultsTarget.innerHTML = users.map((user, index) => `
      <div class="cursor-pointer p-2 hover:bg-gray-100 border-b last:border-b-0"
           data-action="click->autocomplete#select"
           data-autocomplete-email-param="${user.email}"
           data-autocomplete-name-param="${user.name}"
           data-index="${index}">
        <div class="font-medium text-sm text-gray-900">${user.name}</div>
      </div>
    `).join("")

    this.resultsTarget.classList.remove("hidden")
    this.selectedIndex = -1
  }

  select(event) {
    const email = event.currentTarget.dataset.autocompleteEmailParam
    const name = event.currentTarget.dataset.autocompleteNameParam

    this.inputTarget.value = name
    this.hiddenInputTarget.value = email
    this.hideResults()
  }

  hideResults() {
    this.resultsTarget.classList.add("hidden")
    this.resultsTarget.innerHTML = ""
  }

  onKeydown(event) {
    switch(event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.navigateResults(1)
        break
      case "ArrowUp":
        event.preventDefault()
        this.navigateResults(-1)
        break
      case "Enter":
        if (this.selectedIndex > -1) {
          event.preventDefault()
          this.selectIndex(this.selectedIndex)
        }
        break
      case "Escape":
        this.hideResults()
        break
    }
  }

  navigateResults(direction) {
    const items = this.resultsTarget.querySelectorAll("div[data-action='click->autocomplete#select']")
    if (items.length === 0) return

    if (this.selectedIndex > -1) {
      items[this.selectedIndex].classList.remove("bg-gray-100")
    }

    this.selectedIndex += direction
    if (this.selectedIndex < 0) this.selectedIndex = items.length - 1
    if (this.selectedIndex >= items.length) this.selectedIndex = 0

    items[this.selectedIndex].classList.add("bg-gray-100")
    items[this.selectedIndex].scrollIntoView({ block: "nearest" })
  }

  selectIndex(index) {
    const items = this.resultsTarget.querySelectorAll("div[data-action='click->autocomplete#select']")
    if (items[index]) {
      items[index].click()
    }
  }
}
