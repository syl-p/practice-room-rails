import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remote-modal"
export default class extends Controller {
  connect() {
    this.element.showModal();
    this.element.addEventListener('click', (e) =>  this.backdropClick(e));
  }

  backdropClick(event) {
    event.target === this.element && this.close(event)
  }

  close(e) {
    e.preventDefault()
    this.element.close()
  }
}
