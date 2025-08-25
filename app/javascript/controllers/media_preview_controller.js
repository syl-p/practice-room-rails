import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-preview"
export default class extends Controller {
  static targets = ['medium', 'selectedList', 'mediaListLink']
  static outlets = ['media-selection']

  static values = {
    mediumSelected: Array
  }

  connect() {
    window.addEventListener('media:selected', this.updateList.bind(this))

    this.selectedListTarget.innerHTML = this.mediumSelectedValue
        .map(id => this.#createItem(id))
        .join('')
  }

  updateList(event) {
    const {items} = event.detail
    this.mediumTargets.forEach(e => e.remove())

    this.selectedListTarget.innerHTML = items
        .map(({id}) => this.#createItem(id))
        .join('')

    this.#ifEmptyAddEmptyField()
    this.#updateSelectorLink()
  }

  delete({params: {id}}) {
    this.mediumTargets.find(target => parseInt(target.dataset.id) === id)?.remove()
    this.#ifEmptyAddEmptyField()
    this.#updateSelectorLink()
  }

  #createItem(id) {
    return `
          <div data-media-preview-target="medium" 
               data-id="${id}" class="relative border p-2 flex flex-col justify-center">
            ${id}
            <button 
                type="button"
                class="absolute top-1 right-1"
                data-action="click->media-preview#delete:prevent" 
                data-media-preview-id-param="${id}">x</button>
            <input type="hidden" name="activity[medium_ids][]" value="${id}" />
          </div>
    `
  }

  #ifEmptyAddEmptyField() {
    if (this.mediumTargets.length < 1 || !this.mediumSelectedValue) {
      this.selectedListTarget.innerHTML =
          `<input type="hidden" name="activity[medium_ids][]" />`
    }
  }

  #updateSelectorLink() {
    const url = new URL(this.mediaListLinkTarget.href)
    let params = new URLSearchParams(url.search)
    params.delete('selected_ids[]')

    this.mediumTargets.forEach(target => {
      params.append('selected_ids[]', target.dataset.id)
    })

    url.search = params.toString()
    this.mediaListLinkTarget.href = url.toString()
  }
}
