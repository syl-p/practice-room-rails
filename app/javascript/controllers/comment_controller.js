import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
  static targets = [ "form" ]
  static outlets = ["comment"]

  connect() {
  }

  display($event) {
    $event.preventDefault();
    this.formTarget.classList.remove('hidden')

    // Close others
    this.commentOutlets.forEach(comment => {
      if (comment === this) return

      comment.formTarget.classList.add('hidden')
    })
  }

  submit() {
    // fire search
    this.timeout = setTimeout(() => {
      this.formTarget.classList.add('hidden')
      this.formTarget.querySelector('textarea').value = ''
    }, 100)
  }
}