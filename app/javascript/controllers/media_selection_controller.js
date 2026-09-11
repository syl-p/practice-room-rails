import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-selection"
export default class extends Controller {
	/**
	 * @type {Set<String>}
	 */
	#selectedItems = new Set()
  static targets = ['item', 'inputs']
	static values = {
		selectedIds: Array
	}

  connect() {
  }

	itemTargetConnected(checkbox) {
		const id = parseInt(checkbox.value) // checkbox.value is a string
		if (this.selectedIdsValue.includes(id)) {
			this.#addItem(checkbox)
		}

		this.#updateFields()
	}

	itemTargetDisconnected(checkbox) {
		if (this.#selectedItems.has(checkbox.value)) {
			this.#deleteItem(checkbox)
		}

		this.#updateFields()
	}

  toggle({params}) {
		const id = String(params.id)
		const checkbox = this.itemTargets.find(item => item.value === id)
		if (!checkbox) return;

		if (this.#selectedItems.has(checkbox.value)) {
			this.#deleteItem(checkbox)
		} else {
			this.#addItem(checkbox)
		}

		this.#updateFields()
	}

	#updateFields() {
		// this.submitButtonTarget.disabled = this.#selectedItems.size === 0
		this.inputsTarget.innerHTML = [...this.#selectedItems]
			.map(id => `<input type="hidden" id="medium-hidden-input-${id}" name="onboarding_activity_media_step[medium_ids][]" value="${id}"/>`)
			.join("")
	}


	#addItem(checkbox) {
		const card = checkbox.closest('.media-card')

		this.#selectedItems.add(checkbox.value)
		card?.classList.add('selected')
		checkbox.checked = true
	}

	#deleteItem(checkbox) {
		const card = checkbox.closest('.media-card')

		this.#selectedItems.delete(checkbox.value)
		card?.classList.remove('selected')
		checkbox.checked = false
	}
}
