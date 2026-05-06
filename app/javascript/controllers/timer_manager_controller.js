import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timer-manager"
export default class extends Controller {
  static values = {
    activityId: Number,
  }

  connect() {
    this.activityIdValue = null
  }

  start(activityId) {
    if (this.activityIdValue) return

    this.activityIdValue = activityId
    document.dispatchEvent(new CustomEvent('timer:start', {
      detail: {
        activityId
      }
    }))
  }

  stop(activityId) {
    if (!this.activityIdValue) return

    this.activityIdValue = null
    document.dispatchEvent(new CustomEvent('timer:stop'))
  }
}
