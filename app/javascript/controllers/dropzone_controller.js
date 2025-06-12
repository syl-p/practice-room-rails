import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropzone"
export default class extends Controller {
  static targets = ['input']
  static values = {
    draggingClasses: String
  }

  connect() {
    this.element.addEventListener("click", this.openFileDialog.bind(this))
    this.element.addEventListener("dragover", this.dragOver.bind(this))
    this.element.addEventListener("dragleave", this.dragLeave.bind(this))
    this.element.addEventListener("drop", this.drop.bind(this))
  }

  openFileDialog(event) {
    // Ne déclenche pas si on clique sur l'input directement
    if (event.target === this.inputTarget) return
    this.inputTarget.click()
  }

  dragOver(event) {
    event.preventDefault()
    this.element.classList.add(...this.draggingClassesValue.split(" "))
  }

  dragLeave(event) {
    this.element.classList.remove(...this.draggingClassesValue.split(" "))
  }

  drop(event) {
    event.preventDefault()
    this.element.classList.remove(...this.draggingClassesValue.split(" "))

    const files = event.dataTransfer.files
    if (files.length > 0) {
      this.inputTarget.files = files
      this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }
}
