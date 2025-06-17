import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchForm", "searchInput", "clearButton"]

  connect() {
    this.searchTimeout = null
    this.updateClearButtonVisibility()
  }

  confirmRoleUpdate(event) {
    event.preventDefault()
    event.stopPropagation()

    if (event.target.dataset.processing === "true") return

    const userName = event.target.dataset.userManagementUserNameParam
    const action = event.target.dataset.userManagementActionParam

    if (confirm(`Are you sure you want to ${action} ${userName}?`)) {
      event.target.dataset.processing = "true"
      event.target.closest('form').submit()
    }
  }

  confirmUserDelete(event) {
    event.preventDefault()
    event.stopPropagation()

    if (event.target.dataset.processing === "true") return

    const userName = event.target.dataset.userManagementUserNameParam

    if (confirm(`Are you sure you want to delete ${userName}? This action cannot be undone and may fail if the user has associated records.`)) {
      event.target.dataset.processing = "true"
      event.target.closest('form').submit()
    }
  }

  confirmUserDeactivate(event) {
    event.preventDefault()
    event.stopPropagation()

    if (event.target.dataset.processing === "true") return

    const userName = event.target.dataset.userManagementUserNameParam

    if (confirm(`Are you sure you want to deactivate ${userName}'s membership? This will end their current membership but preserve all historical data.`)) {
      event.target.dataset.processing = "true"
      event.target.closest('form').submit()
    }
  }

  submitSearch(event) {
    clearTimeout(this.searchTimeout)
    this.updateClearButtonVisibility()

    this.searchTimeout = setTimeout(() => {
      const currentValue = event.target.value
      const minLength = 2

      if (currentValue.length >= minLength || currentValue.length === 0) {
        this.performSearch()
      }
    }, 500)
  }

  clearSearch(event) {
    event.preventDefault()
    if (this.hasSearchInputTarget) {
      this.searchInputTarget.value = ''
      this.updateClearButtonVisibility()
      this.performSearch()
      this.searchInputTarget.focus()
    }
  }

  filterChanged(event) {
    this.performSearch()
  }

  performSearch() {
    if (this.hasSearchFormTarget) {
      this.searchFormTarget.requestSubmit()
    }
  }

  updateClearButtonVisibility() {
    if (this.hasClearButtonTarget && this.hasSearchInputTarget) {
      if (this.searchInputTarget.value.length > 0) {
        this.clearButtonTarget.classList.remove('hidden')
      } else {
        this.clearButtonTarget.classList.add('hidden')
      }
    }
  }

  disconnect() {
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }
  }
}
