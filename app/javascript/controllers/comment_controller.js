import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
  static values = {
    hiddenClasses: String
  }
  static targets = [ "form" ]

  connect() {
  }

  display($event) {
    $event.preventDefault();
    this.formTarget.classList.remove(this.hiddenClassesValue)
  }

  submit() {
    // fire search
    this.timeout = setTimeout(() => {
      this.formTarget.classList.add(this.hiddenClassesValue)
      this.formTarget.querySelector('textarea').value = ''
    }, 100)
  }
}