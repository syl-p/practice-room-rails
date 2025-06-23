import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-form"
export default class extends Controller {
  connect() {
  }

  change(e) {
    this.element.submit()
  }
}
