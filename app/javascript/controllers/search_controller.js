import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input"]
  static values = { url: String }

  connect() {
    this.debounce = setTimeout(() => {})
  }

  change() {
    clearTimeout(this.debounce)
    this.search()
  }

  search() {
    this.debounce = setTimeout(() => {
      if (this.hasUrlValue) {
        const url = new URL(this.urlValue, window.location.origin)
        if (this.inputTarget.value.trim().length > 0) {
          url.searchParams.set("pattern", this.inputTarget.value.trim())
        }
        Turbo.visit(url, { frame: "media_list", action: "replace" })
      } else {
        this.inputTarget.closest("form")?.requestSubmit()
      }
    }, 500)
  }
}