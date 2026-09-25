import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="countdown-timer"
export default class extends Controller {
	static values = {
		activityId: Number,
		stepMinutes: { type: Number, default: 5 },
	}

	static targets = [
		"toggleBtn", "display", "readout", "timeInput", "inputValue", "submitButton",
		"setup", "decrease", "increase", "idle", "playing", "paused",
	]

	static MINUTES = { min: 1, max: 120 }

	connect() {
		this.state = "idle"
		this.timerInterval = null
		this.endAt = null
		this.totalSeconds = this.#minutesFromInput() * 60
		this.remainingSeconds = this.totalSeconds

		this.element.addEventListener("turbo:submit-end", (event) => this.#onSubmitEnd(event))
		document.addEventListener("timer:start", (e) => this.#onStart(e))
		document.addEventListener("timer:stop", () => this.#onStop())

		this.#render()
		this.#setUI()
	}

	disconnect() {
		clearInterval(this.timerInterval)
	}

	get manager() {
		const el = document.querySelector("[data-controller~='timer-manager']")
		if (!el) return null
		return this.application.getControllerForElementAndIdentifier(el, "timer-manager")
	}

	// --- Sélection de la durée (idle uniquement) ---

	durationChanged() {
		if (this.state !== "idle") return
		this.totalSeconds = this.#minutesFromInput() * 60
	}

	increase() {
		if (this.state !== "idle") return
		const minutes = Math.min(this.constructor.MINUTES.max, this.#minutesFromInput())
		this.#setMinutes(minutes + this.stepMinutesValue)
	}

	decrease() {
		if (this.state !== "idle") return
		const minutes = Math.max(this.constructor.MINUTES.min, this.#minutesFromInput())
		this.#setMinutes(minutes - this.stepMinutesValue)
	}

	#setMinutes(minutes) {
		const clamped = Math.min(this.constructor.MINUTES.max, Math.max(this.constructor.MINUTES.min, minutes))
		this.totalSeconds = clamped * 60
		this.timeInputTarget.value = this.#toTimeInput(clamped * 60)
	}

	#minutesFromInput() {
		const [h = 0, m = 0] = (this.timeInputTarget.value || "00:25").split(":").map(Number)
		let minutes = h * 60 + m
		if (!Number.isFinite(minutes) || minutes < 1) minutes = this.constructor.MINUTES.min
		return Math.min(minutes, this.constructor.MINUTES.max)
	}

	#toTimeInput(seconds) {
		const h = String(Math.floor(seconds / 3600)).padStart(2, "0")
		const m = String(Math.floor((seconds % 3600) / 60)).padStart(2, "0")
		return `${h}:${m}`
	}

	// --- Contrôle du minuteur ---

	toggle() {
		if (this.state === "running") this.pause()
		else this.start()
	}

	start() {
		if (this.state === "running") return

		if (this.state === "idle") {
			this.totalSeconds = this.#minutesFromInput() * 60
			this.remainingSeconds = this.totalSeconds
		}
		if (this.remainingSeconds <= 0) return

		this.state = "running"
		this.endAt = Date.now() + this.remainingSeconds * 1000
		this.timerInterval = setInterval(() => this.#tick(), 250)

		this.#setUI()
		if (this.manager) this.manager.start(this.activityIdValue)
	}

	pause() {
		if (this.state !== "running") return

		clearInterval(this.timerInterval)
		this.timerInterval = null
		this.remainingSeconds = Math.max(0, Math.ceil((this.endAt - Date.now()) / 1000))
		this.state = "paused"

		// Durée réellement pratiquée (arrêt anticipé)
		this.inputValueTarget.value = this.totalSeconds - this.remainingSeconds

		this.#render()
		this.#setUI()
	}

	#tick() {
		const remainingMs = this.endAt - Date.now()
		if (remainingMs <= 0) {
			this.#finish()
			return
		}
		this.remainingSeconds = Math.ceil(remainingMs / 1000)
		this.#render()
	}

	#finish() {
		clearInterval(this.timerInterval)
		this.timerInterval = null
		this.remainingSeconds = 0
		this.#render()

		this.inputValueTarget.value = this.totalSeconds
		if (this.manager) this.manager.stop()

		if (this.element.dataset.autoSubmit !== "false") {
			this.element.requestSubmit()
		} else {
			this.state = "paused"
			this.#setUI()
		}
	}

	#onSubmitEnd(event) {
		if (event?.target?.id === this.element.id) this.#reset()
		if (this.manager) {
			this.state = "idle"
			this.manager.stop()
		}
	}

	#reset() {
		this.state = "idle"
		this.endAt = null
		clearInterval(this.timerInterval)
		this.timerInterval = null
		this.inputValueTarget.value = null

		this.totalSeconds = this.#minutesFromInput() * 60
		this.remainingSeconds = this.totalSeconds
		this.#render()
		this.#setUI()
	}

	// --- UI ---

	#setUI() {
		this.setupTarget.classList.toggle("hidden", this.state !== "idle")
		this.displayTarget.classList.toggle("hidden", this.state === "idle")
		this.submitButtonTarget.classList.toggle("hidden", this.state !== "paused")

		const visible = this.state === "running" ? "playing"
			: this.state === "paused" ? "paused"
				: "idle"
		;[this.idleTarget, this.playingTarget, this.pausedTarget].forEach((el) => {
			el.classList.toggle("hidden", el !== this[`${visible}Target`])
		})
		this.toggleBtnTarget.disabled = false
	}

	#render() {
		this.readoutTarget.textContent = this.#format(this.remainingSeconds)
	}

	#format(seconds) {
		const m = String(Math.floor(seconds / 60)).padStart(2, "0")
		const s = String(seconds % 60).padStart(2, "0")
		return `${m}:${s}`
	}

	// --- Un seul timer à la fois (timer-manager) ---

	#onStart(event) {
		if (event.detail.activityId !== this.activityIdValue) this.toggleBtnTarget.disabled = true
	}

	#onStop() {
		this.toggleBtnTarget.disabled = false
	}
}