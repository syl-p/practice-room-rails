import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-selection"
export default class extends Controller {
  static targets = ['item']

  connect() {
  }

  submit() {
    const items = this.itemTargets.filter(cbx => cbx.checked).map(cbx => ({
      id: cbx.value,
      thumbUrl: cbx.dataset.thumbUrl
    }))

    window.dispatchEvent(new CustomEvent('media:selected', {
      detail: {
        items
      }
    }))
  }
}
