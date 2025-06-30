import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notifications"
export default class extends Controller {
  static targets = ['indicator']
  connect() {
    document.addEventListener('turbo:before-stream-render', this.notify.bind(this))
  }

  notify(event) {
    const stream = event.target

    // Vérifie que c’est une notification qui vient d’arriver (ex: prepend dans #notifications)
    const isNotification = stream.action === "prepend" && stream.target === "notifications"

    if (isNotification && this.hasIndicatorTarget) {
      this.indicatorTarget.classList.remove("hidden")
    }
  }
}
