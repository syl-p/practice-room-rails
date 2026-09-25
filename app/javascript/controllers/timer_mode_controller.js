import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timer-mode"
export default class extends Controller {
	static values = { activityId: Number }
	static targets = [ "switcher", "chrono", "minuteur" ]

	connect() {
		this.#apply(localStorage.getItem(this.#storageKey()) || "chrono")
	}

	select(event) {
		const mode = event.params.mode
		localStorage.setItem(this.#storageKey(), mode)
		this.#apply(mode)
	}

	#storageKey() {
		return `timer:mode:${this.activityIdValue}`
	}

	#apply(mode) {
		this.chronoTarget.classList.toggle("hidden", mode !== "chrono")
		this.minuteurTarget.classList.toggle("hidden", mode !== "minuteur")

		this.switcherTarget.querySelectorAll("[data-timer-mode-mode-param]").forEach((btn) => {
			const active = btn.dataset.timerModeModeParam === mode
			btn.setAttribute("data-active", active)
			//btn.setAttribute("aria-pressed", active ? "true" : "false")
		})
	}
}