import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="btn-timer"
export default class extends Controller {
  static targets = ["playBtn", "pauseBtn", "display", "input", "submitButton"]

  connect() {
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
  }

  disconnect() {
    clearInterval(this.timerInterval)
    this.element.removeEventListener("turbo:submit-end",  (event) => {
      this.onSubmitEnd(event)
    })
  }

  start(e) {
    e.preventDefault()
    
    this.startedAt = Date.now()
    this.element.dataset.startedAt = this.startedAt

    this.pauseBtnTarget.classList.remove("hidden")
    this.playBtnTarget.classList.add("hidden")

    // tick
    this.#startInterval()
  }

  pause(e) {
    e.preventDefault()
    clearInterval(this.timerInterval)

    this.elapsedTime += Date.now() - this.startedAt
    this.element.dataset.elapsedTime = this.elapsedTime
    delete this.element.dataset.startedAt

    this.inputTarget.value = Math.floor(this.elapsedTime / 1000)

    this.startedAt = null
    clearInterval(this.timerInterval)
    this.timerInterval = null

    this.pauseBtnTarget.classList.add("hidden")
    this.playBtnTarget.classList.remove("hidden")
    this.submitButtonTarget.classList.remove("hidden")
  }

  onSubmitEnd(event) {
    if (event?.target?.id === this.element.id) {
      this.#reset()
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
    this.playBtnTarget.classList.remove("hidden")
    this.pauseBtnTarget.classList.add("hidden")
    this.submitButtonTarget.classList.add("hidden")
    this.displayTarget.textContent = "--:--"
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
}
