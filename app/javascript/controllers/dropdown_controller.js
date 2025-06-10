import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ['triggerBtn', 'dropdownMenu']

  connect() {
    document.addEventListener('click', (e) => {
      if (!this.dropdownMenuTarget.contains(e.target) && !this.triggerBtnTarget.contains(e.target)
          && !this.dropdownMenuTarget.classList.contains('hidden')) {
        this.dropdownMenuTarget.classList.add('hidden')
      }
    })
  }

  toggle() {
    this.dropdownMenuTarget.classList.toggle('hidden')
  }
}
