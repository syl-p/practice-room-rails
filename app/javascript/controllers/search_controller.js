import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.debounce = setTimeout(() => {})
  }

  change(e) {
    clearTimeout(this.debounce)
    this.search()
  }

  search() {
    this.debounce = setTimeout(() => {
      this.inputTarget.closest('form')?.requestSubmit()
    }, 500)
  }
}