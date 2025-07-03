import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static  targets = ['toast']
  connect() {
    requestAnimationFrame(() => {
      this.toastTarget.classList.remove("-translate-x-full")
      this.toastTarget.classList.add("translate-x-0")
    })

    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    this.toastTarget.classList.add(
        "opacity-0",
        "transition-opacity",
        "duration-300",
        "-translate-x-full"
    )
    setTimeout(() => {
      this.toastTarget.remove()
    }, 300)
  }
}
