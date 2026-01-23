import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tag-selector"
export default class extends Controller {
  static targets = ['input', 'dataToSend', 'listToShow']
  static values = {
    searchUrl: String,
    preselectedTags: [],
    tagClasses: String
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

  confirmTag(event) {
    event.preventDefault()
    event.stopPropagation()

    const tag = this.inputTarget.value.trim()
    if (!tag) return;
    if(this.selectedTags.includes(tag)) return

    this.selectedTags.push(tag)
    this.inputTarget.value = ""
    this.#render()
  }

  selectTag({params: {value}}) {
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
      li.innerHTML = `
        <div class="${this.tagClassesValue}" >
            ${tagLabel}
            <button 
                class="ml-2 text-black font-bold"
                data-label="${tagLabel}"
                data-action="click->tags-selector#deleteTag:stop">
                &times
            </button>
        </div>
      `
      this.listToShowTarget.appendChild(li)
    })

    // UPDATE HIDDEN INPUT
    this.dataToSendTarget.value = this.selectedTags.join(',')
  }
}
