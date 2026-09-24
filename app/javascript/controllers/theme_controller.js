import { Controller } from "@hotwired/stimulus"

// Boutons radio du sélecteur de thème : clair / sombre / système.
// Persiste dans localStorage et bascule la classe `.dark` sur <html>.
export default class extends Controller {
  static targets = ["option"]
  static STORAGE_KEY = "practice-room:theme"

  connect() {
    this.mql = window.matchMedia("(prefers-color-scheme: dark)")
    this.onSystemChange = this.apply.bind(this)
    this.mql.addEventListener("change", this.onSystemChange)
    this.apply()
  }

  disconnect() {
    this.mql?.removeEventListener("change", this.onSystemChange)
  }

  theme() {
    return localStorage.getItem(this.constructor.STORAGE_KEY) || "system"
  }

  apply() {
    const theme = this.theme()
    const dark = theme === "dark" || (theme === "system" && this.mql?.matches)
    document.body.classList.toggle("dark", dark)
    this.optionTargets.forEach((el) => {
      const active = el.dataset.themeValue === theme
      el.setAttribute("aria-checked", String(active))
      el.classList.toggle("bg-card", active)
      el.classList.toggle("text-foreground", active)
      el.classList.toggle("shadow-sm", active)
      el.classList.toggle("text-muted-foreground", !active)
    })
  }

  select(event) {
    localStorage.setItem(this.constructor.STORAGE_KEY, event.currentTarget.dataset.themeValue)
    this.apply()
  }
}