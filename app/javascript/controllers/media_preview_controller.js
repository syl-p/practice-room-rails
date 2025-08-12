import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-preview"
export default class extends Controller {
  static targets = ['medium', 'selectedList', 'mediaListLink']
  static values = {
    mediumSelected: Array
  }

  connect() {
    window.addEventListener('media:selected', this.updateList.bind(this))

    this.selectedListTarget.innerHTML = this.mediumSelectedValue
        .map(id => this.createItem(id))
        .join('')
  }

  updateList(event) {
    const {items} = event.detail
    this.mediumTargets.forEach(e => e.remove())

    this.selectedListTarget.innerHTML = items
        .map(({id}) => this.createItem(id))
        .join('')
  }

  delete({params: {id}}) {
    this.mediumTargets.find(target => target.dataset.id === id)?.remove()
  }

  createItem(id) {
    return `
          <div data-media-preview-target="medium" class="relative border p-2 flex flex-col justify-center">
            ${id}
            <button 
                class="absolute top-1 right-1"
                data-action="click->media-preview#delete" 
                data-id-param="${id}">x</button>
            <input type="hidden" name="activity[medium_ids][]" value="${id}" />
          </div>
    `
  }
}
