import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropzone"
export default class extends Controller {
  static targets = ['input', 'list', 'item']
  static values = {
    uploadUrl: String,
    draggingClasses: String
  }

  connect() {
    this.element.addEventListener("click", this.openFileDialog.bind(this))
    this.element.addEventListener("dragover", this.dragOver.bind(this))
    this.element.addEventListener("dragleave", this.dragLeave.bind(this))
    this.element.addEventListener("drop", this.drop.bind(this))

    this.items = []
  }

  inputTargetConnected(input) {
    input.addEventListener("change", this.#refreshList.bind(this))
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
      this.inputTarget.dispatchEvent(new Event("change"))
    }
  }

  #refreshList() {
    this.items = []

    // Update items property
    Array.from(this.inputTarget.files).forEach((file, index) => {
      const reader = this.#getReader(file)
      reader.onload = (e) => {
        const item = {
          index,
          file: file,
          name: file.name,
          path: reader.result
        }

        this.items.push(item)
        this.#appendItemToList(item)
      }
    })
  }

  #getReader(file) {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    return reader
  }

  #appendItemToList(item) {
    const li = document.createElement('li')
    li.dataset.id = item.index

    li.innerHTML = `
        <div data-dropzone-target="item" class="border p-3 mb-3">
          <div class="flex space-x-3">
            <p>${item.name}</p>
            <button
              data-action="click->dropzone#removeFile" 
              data-dropzone-index-param="${item.index}">
              x
            </button>
          </div>
          <progress class="hidden" value="0" max="100" style="width: 100%;"></progress>
          <p class="status"></p>
        </div>
    `


    this.listTarget.appendChild(li)
  }

  removeFile(e) {
    e.preventDefault()
    e.stopPropagation()
    const index = e.params.index

    this.items.splice(index, 1)
    const li = this.listTarget.querySelector(`[data-id="${index}"]`)

    if(li)
      this.listTarget.removeChild(li)

    const dataTransfer = new DataTransfer()
    this.items.forEach(item => dataTransfer.items.add(item.file))
    this.inputTarget.files = dataTransfer.files
  }

  #uploadFile(item) {
    const li = this.listTarget.querySelector(`[data-id="${item.index}"]`)
    const status = li.querySelector('.status')
    const progress = li.querySelector('progress')

    const formData = new FormData()
    formData.append('file', item.file)

    const xhr = new XMLHttpRequest()
    xhr.open("POST", this.uploadUrlValue, true)
    xhr.setRequestHeader("X-CSRF-Token", document.querySelector("meta[name=csrf-token]").content)

    // ON PROGRESS
    xhr.upload.addEventListener('progress', (event) => {
      if (event.lengthComputable) {
        progress.classList.remove('hidden')
        progress.value = Math.round((event.loaded / event.total) * 100)
      }
    })

    // ON FINISH
    xhr.onload = () => {
      if (xhr.status === 201) {
        progress.classList.add('hidden')
        const response = JSON.parse(xhr.responseText)
        status.textContent = "✅ Upload réussi"
      } else {
        status.textContent = "❌ Échec création Medium"
      }
    }

    xhr.onerror = () => {
      status.textContent = "❌ Erreur réseau"
    }

    xhr.send(formData)
  }

  submit(event) {
    event.preventDefault()
    event.stopPropagation()

    this.items.forEach(item => {
      this.#uploadFile(item)
    })
  }
}
