import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="btn-timer"
export default class extends Controller {
  static values = {
    activityId: Number,
    playLabel: String,
    pauseLabel: String
  }

  static targets = ["toggleBtn", "display", "input", "submitButton"]

  connect() {
    this.state = "idle"

    this.startedAt = this.element.dataset.startedAt ? parseInt(this.element.dataset.startedAt, 10) : null
    this.elapsedTime = this.element.dataset.elapsedTime
        ? parseInt(this.element.dataset.elapsedTime, 10)
        : 0

    this.timerInterval = null

    if(this.startedAt) {
      this.#startInterval()
    }

    this.element.addEventListener('turbo:submit-end',  (event) => {
      this.onSubmitEnd(event)
    })

    document.addEventListener('timer:start', (e) => this.#onStart(e))
    document.addEventListener('timer:stop', () => this.#onStop())
  }

  disconnect() {
    clearInterval(this.timerInterval)
    this.element.removeEventListener("turbo:submit-end",  (event) => {
      this.onSubmitEnd(event)
    })
  }

  get manager() {
    const el = document.querySelector("[data-controller~='timer-manager']")
    if (!el) return null

    return this.application.getControllerForElementAndIdentifier(
        el,
        "timer-manager"
    )
  }

  toggle() {
    if (this.state === "running") {
      this.pause()
    } else {
      this.start()
    }
  }

  start() {
    this.state = "running"

    this.startedAt = Date.now()
    this.element.dataset.startedAt = this.startedAt

    // tick
    this.#startInterval()

    // Update Manager
    if (this.manager) this.manager.start(this.activityIdValue)

    this.toggleBtnTarget.innerHTML = this.pauseLabelValue
  }

  pause(e) {
    this.state = "paused"
    clearInterval(this.timerInterval)

    this.elapsedTime += Date.now() - this.startedAt
    this.element.dataset.elapsedTime = this.elapsedTime
    delete this.element.dataset.startedAt

    this.inputTarget.value = Math.floor(this.elapsedTime / 1000)

    this.startedAt = null
    clearInterval(this.timerInterval)
    this.timerInterval = null

    this.submitButtonTarget.classList.remove("hidden")
    this.toggleBtnTarget.innerHTML = this.playLabelValue
  }

  onSubmitEnd(event) {
    if (event?.target?.id === this.element.id) {
      this.#reset()
    }

    // Update Manager
    if (this.manager) {
      this.state = "idle"
      this.manager.stop()
    }
  }

  #reset() {
    this.startedAt = null
    this.elapsedTime = 0

    clearInterval(this.timerInterval)
    this.timerInterval = null
    this.inputTarget.value = null

    delete this.element.dataset.elapsedTime
    delete this.element.dataset.startedAt

    // UI
    this.toggleBtnTarget.innerHTML = this.playLabelValue
    this.displayTarget.textContent = "--:--"
    this.submitButtonTarget.classList.add("hidden")
  }


  #render() {
    const running = this.startedAt ? Date.now() - this.startedAt : 0
    this.#updateDisplay(this.elapsedTime + running)
  }

  #startInterval() {
    this.timerInterval = setInterval(() => {
      this.#render()
    }, 500)
  }

  #updateDisplay(ms) {
    const totalSeconds = Math.floor(ms / 1000)
    const minutes = String(Math.floor(totalSeconds / 60)).padStart(2, "0")
    const seconds = String(totalSeconds % 60).padStart(2, "0")
    this.displayTarget.textContent = `${minutes}:${seconds}`
  }

  #onStart(event) {
    const {activityId} = event.detail
    if (activityId !== this.activityIdValue) {
      this.#disable()
    }
  }

  #onStop() {
    console.log("stop")
    this.#enable()
  }

  #disable() {
    this.toggleBtnTarget.disabled = true
  }

  #enable() {
    this.toggleBtnTarget.disabled = false
  }
}
