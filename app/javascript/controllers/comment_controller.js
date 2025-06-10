import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
  static targets = [ "form" ]

  connect() {
  }

  display($event) {
    $event.preventDefault();
    this.formTarget.classList.remove('hidden')
  }

  submit() {
    // fire search
    this.timeout = setTimeout(() => {
      this.formTarget.classList.add('hidden')
      this.formTarget.querySelector('textarea').value = ''
    }, 100)
  }
}