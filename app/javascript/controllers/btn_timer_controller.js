import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="btn-timer"
export default class extends Controller {
  static values = {
    hiddenClasses: String
  }
  bb
  static targets = ["playBtn", "pauseBtn", "display", "input", "submitButton"]

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

  start(e) {
    e.preventDefault()
    this.pauseBtnTarget.classList.remove(this.hiddenClassesValue)
    this.playBtnTarget.classList.add(this.hiddenClassesValue)
    this.running = true
    this.startTime = Date.now()
    this.timerInterval = setInterval(() => {
      const now = Date.now()
      const total = this.elapsedTime + (now - this.startTime)
      this.#updateDisplay(total)
    }, 500)
  }

  pause(e) {
    e.preventDefault()
    this.running = false
    clearInterval(this.timerInterval)
    const now = Date.now()
    this.elapsedTime += now - this.startTime
    this.#updateDisplay(this.elapsedTime)
    this.inputTarget.value = Math.floor(this.elapsedTime / 1000)
    this.pauseBtnTarget.classList.add(this.hiddenClassesValue)
    this.playBtnTarget.classList.remove(this.hiddenClassesValue)
    this.submitButtonTarget.classList.remove(this.hiddenClassesValue)
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
    this.pauseBtnTarget.classList.add(this.hiddenClassesValue)
    this.submitButtonTarget.classList.add(this.hiddenClassesValue)
    this.displayTarget.textContent = "--:--"
    this.#updateDisplay(0)
  }

  #updateDisplay(ms) {
    const totalSeconds = Math.floor(ms / 1000)
    const minutes = String(Math.floor(totalSeconds / 60)).padStart(2, "0")
    const seconds = String(totalSeconds % 60).padStart(2, "0")
    this.displayTarget.textContent = `${minutes}:${seconds}`
  }
}
