import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tag-selector"
export default class extends Controller {
  static targets = ['input', 'dataToSend', 'listToShow']
  static values = {
    searchUrl: String,
    preselectedTags: [],
    tagClasses: String,
    closeBtnClasses: String
  }

  connect() {
    this.debounce = null
    this.selectedTags = [...this.preselectedTagsValue]

    this.#render()
  }

  search() {
    clearTimeout(this.debounce)
    this.debounce = setTimeout(() => {
      this.fetchTags()
    }, 500)
  }

  fetchTags() {
    const pattern = this.inputTarget.value.trim()
    if (!pattern) return

    fetch(
        `${this.searchUrlValue}?pattern=${encodeURIComponent(pattern)}`,
        {headers: { Accept: "text/vnd.turbo-stream.html" }})
        .then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html))
  }

  selectTag({params: {value}}) {
    if (!value) return;
    if(this.selectedTags.includes(value)) return

    this.selectedTags.push(value)
    this.inputTarget.value = ""
    this.#render()
  }

  deleteTag(event) {
    event.preventDefault()
    const label = event.target.dataset.label
    this.selectedTags = this.selectedTags.filter(tag => tag !== label)
    this.#render()
  }

  #render() {
    // RENDER LIST
    this.listToShowTarget.innerHTML = '' // clear list
    this.selectedTags.forEach((tagLabel, index) => {
      const li = document.createElement("li")
      li.classList.add(this.tagClassesValue)

      li.innerHTML = `
        <div class="${this.tagClassesValue}" >
            ${tagLabel}
            <a 
                aria-label="Close" role="button"
                class="${this.closeBtnClassesValue}"
                data-label="${tagLabel}"
                data-action="click->tags-selector#deleteTag:stop">
            </a>
        </div>
      `
      this.listToShowTarget.appendChild(li)
    })

    // UPDATE HIDDEN INPUT
    this.dataToSendTarget.value = this.selectedTags.join(',')
  }
}
