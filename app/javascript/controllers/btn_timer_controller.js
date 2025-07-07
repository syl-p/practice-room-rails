import { Controller } from "@hotwired/stimulus"
const START_LABEL = "Pratiquer"
const PAUSE_LABEL = "Pause"
const RESUME_LABEL = "Continuer"

// Connects to data-controller="btn-timer"
export default class extends Controller {
  static targets = ["button", "label", "display", "input", "submitButton"]

  connect() {
    this.running = false
    this.startTime = null
    this.elapsedTime = 0
    this.timerInterval = null
    this.element.addEventListener('turbo:submit-end',  (event) => {
      this.onSubmitEnd(event)
    })
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-end",  (event) => {
      this.onSubmitEnd(event)
    })
  }

  toggle(e) {
    this.displayTarget.classList.remove("hidden")

    e.preventDefault()
    if(this.running) {
      this.pause()
    } else {
      this.start()
    }
  }

  start() {
    this.submitButtonTarget.classList.add("hidden")
    this.running = true
    this.startTime = Date.now()
    this.labelTarget.textContent = PAUSE_LABEL
    this.timerInterval = setInterval(() => {
      const now = Date.now()
      const total = this.elapsedTime + (now - this.startTime)
      this.#updateDisplay(total)
    }, 500)
  }

  pause() {
    this.running = false
    clearInterval(this.timerInterval)
    const now = Date.now()
    this.elapsedTime += now - this.startTime
    this.#updateDisplay(this.elapsedTime)
    this.inputTarget.value = Math.floor(this.elapsedTime / 1000)
    this.labelTarget.textContent = RESUME_LABEL
    this.submitButtonTarget.classList.remove("hidden")
  }

  onSubmitEnd(event) {
    if (event?.target?.id === this.element.id) {
      this.#reset()
    }
  }

  #reset() {
    this.running = false
    this.startTime = null
    this.timerInterval = null
    this.inputTarget.value = null
    this.elapsedTime = 0

    // UI
    this.displayTarget.classList.add("hidden")
    this.submitButtonTarget.classList.add("hidden")
    this.displayTarget.textContent = ""
    this.labelTarget.textContent = START_LABEL
    this.#updateDisplay(0)
  }

  #updateDisplay(ms) {
    const totalSeconds = Math.floor(ms / 1000)
    const minutes = String(Math.floor(totalSeconds / 60)).padStart(2, "0")
    const seconds = String(totalSeconds % 60).padStart(2, "0")
    this.displayTarget.textContent = `${minutes}:${seconds}`
  }
}
