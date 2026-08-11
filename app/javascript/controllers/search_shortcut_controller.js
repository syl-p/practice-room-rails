import { Controller } from "@hotwired/stimulus"

// Ouverture de la recherche au raccourci clavier "/" (desktop uniquement)
export default class extends Controller {
  static targets = ["trigger"]

  connect() {
    this.onKeydown = (event) => this.handleKeydown(event)
    document.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
  }

  handleKeydown(event) {
    if (event.key !== "/" || !this.hasTriggerTarget) return
    if (!window.matchMedia("(min-width: 1024px)").matches) return

    const target = event.target
    if (target instanceof HTMLInputElement ||
        target instanceof HTMLTextAreaElement ||
        target.isContentEditable) return

    event.preventDefault()
    this.triggerTarget.click()
  }
}
