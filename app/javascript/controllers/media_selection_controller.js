import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-selection"
export default class extends Controller {
	#selectedItems = new Set()
  static targets = ['item', 'inputs', 'submitButton']
	static values = {
		selectedIds: Array
	}

  connect() {
		this.selectedIdsValue.map(String).forEach(id => {
			this.#selectedItems.add(id)
			this.#preSelect(id)
		})
		this.#updateUi()
  }

  toggle({params}) {
		const id = String(params.id)

		if(this.#selectedItems.has(id)) {
			this.#selectedItems.delete(id)
		} else {
			this.#selectedItems.add(id)
		}
		this.#updateUi()
	}

	#updateUi() {
		// this.submitButtonTarget.disabled = this.#selectedItems.size === 0
		this.inputsTarget.innerHTML = [...this.#selectedItems]
			.map(id => `<input type="hidden" name="onboarding_activity_media_step[medium_ids][]" value="${id}"/>`)
			.join("")
	}

	#preSelect(id) {
		const checkbox = this.itemTargets.find(item => item.value === id)
		if (checkbox) checkbox.checked = true
	}
}
