import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tag-selector"
export default class extends Controller {
  static targets = ['input', 'suggestions', 'dataToSend', 'listToShow']
  static values = {
    searchUrl: String,
    preselectedTags: [],
    tagClasses: String
  }

  connect() {
    this.debounce = null
    this.selectedTags = new Map()
    this.preselectedTagsValue.forEach(t => {
      this.selectedTags.set(t.id, t.name)
    })

    this.#updateListToShow()
    this.#updateDataToSend()
  }

  search() {
    clearTimeout(this.debounce)
    this.debounce = setTimeout(() => {
      this.fetchTags()
    }, 500)
  }

  fetchTags() {
    const pattern = this.inputTarget.value.trim()
    fetch(
        `${this.searchUrlValue}?pattern=${encodeURIComponent(pattern)}`,
        {headers: { Accept: "text/vnd.turbo-stream.html" }})
        .then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html))
  }

  selectTag({params: {id, name}}) {
    this.selectedTags.set(id, name)
    this.listToShowTarget.innerHTML = ''
    this.#updateDataToSend()
    this.#updateListToShow()
  }

  deleteTag({params: {id}}) {
    this.listToShowTarget.querySelector(`[data-id="${id}"]`).remove()
    this.selectedTags.delete(id)
    this.#updateDataToSend()
    this.#updateListToShow()
  }

  #updateDataToSend() {
    this.dataToSendTarget.value = Array.from(this.selectedTags.keys()).join(',')
  }

  #updateListToShow() {
    this.listToShowTarget.innerHTML = ''
    this.selectedTags.forEach((name, id) => {
      const li = document.createElement("li")
      li.innerHTML = `
        <div class="${this.tagClassesValue}" >
            ${name}
            <button 
                class="ml-2 text-black font-bold"
                data-id="${id}"
                data-action="click->tags-selector#deleteTag" 
                data-tags-selector-id-param="${id}">
                &times
            </button>
        </div>
      `
      this.listToShowTarget.appendChild(li)
    })
  }
}
