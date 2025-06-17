import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["dialog", "input"]

  connect() {
    this.debounce = setTimeout(() => {})
  }

  toggle(e) {
    e.preventDefault();
    this.dialogTarget.showModal()
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

  closeOnSelfClick(e) {
    if (e.target === this.dialogTarget) {
      this.inputTarget.value = ''
      this.dialogTarget.close()
    }
  }
}