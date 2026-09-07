import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-library"
export default class extends Controller {
	static targets = ['emptyState', 'item']

  connect() {
  }

	itemTargetConnected() {
		this.#updateEmptyStateShow()
	}

	itemTargetDisconnected() {
		this.#updateEmptyStateShow()
	}

	#updateEmptyStateShow() {
		if(this.itemTargets.length > 0) {
			this.emptyStateTarget.classList.add('hidden')
		} else {
			this.emptyStateTarget.classList.remove('hidden')
		}
	}
}
