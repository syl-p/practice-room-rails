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
			this.#updateItem(id)
		})
		this.#updateFields()
  }

  toggle({params}) {
		const id = String(params.id)
		this.#updateItem(id)
		this.#updateFields()
	}

	#updateFields() {
		this.submitButtonTarget.disabled = this.#selectedItems.size === 0

		this.inputsTarget.innerHTML = [...this.#selectedItems]
			.map(id => `<input type="hidden" id="medium-hidden-input-${id}" name="onboarding_activity_media_step[medium_ids][]" value="${id}"/>`)
			.join("")
	}

	#updateItem(id) {
		const checkbox = this.itemTargets.find(item => item.value === id)
		const card = checkbox?.closest('.media-card')

		if(this.#selectedItems.has(id)) {
			this.#selectedItems.delete(id)
			card?.classList.remove('selected')
			checkbox.checked = false
		} else {
			this.#selectedItems.add(id)
			card?.classList.add('selected')
			checkbox.checked = true
		}
	}
}
