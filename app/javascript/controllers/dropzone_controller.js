import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropzone"
export default class extends Controller {
  static targets = ['dropContainer', 'input', 'list', 'itemTemplate']
  static values = {
    uploadUrl: String,
    draggingClasses: String
  }

  connect() {
    this.dropContainerTarget.addEventListener("click", this.openFileDialog.bind(this))
    this.dropContainerTarget.addEventListener("dragover", this.dragOver.bind(this))
    this.dropContainerTarget.addEventListener("dragleave", this.dragLeave.bind(this))
    this.dropContainerTarget.addEventListener("drop", this.drop.bind(this))

    this.items = []
  }

  inputTargetConnected(input) {
    input.addEventListener("change", async () => {
			await this.#refreshList()
			this.submit()
		})
  }

  openFileDialog(event) {
    // Ne déclenche pas si on clique sur l'input directement
    if (event.target === this.inputTarget) return
    this.inputTarget.click()
  }

  dragOver(event) {
    event.preventDefault()
    this.dropContainerTarget.classList.add(...this.draggingClassesValue.split(" "))
  }

  dragLeave(event) {
    this.dropContainerTarget.classList.remove(...this.draggingClassesValue.split(" "))
  }

  drop(event) {
    event.preventDefault()
    this.dropContainerTarget.classList.remove(...this.draggingClassesValue.split(" "))

    const files = event.dataTransfer.files

		if (files.length > 0) {
      this.inputTarget.files = files
      this.inputTarget.dispatchEvent(new Event("change"))
    }
  }

	async #refreshList() {
		this.items = []
		const files = Array.from(this.inputTarget.files)

		await Promise.all(files.map((file, index) => {
			return new Promise((resolve, _reject) => {
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
					resolve()
				}
			})
		}))
	}

  #getReader(file) {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    return reader
  }

  #appendItemToList(item) {
    const preview = document.createElement('div')
		preview.setAttribute("id", `upload-${item.index}`)
		preview.setAttribute("class", "media-card uploading")

		const isImage = item.file.type.startsWith('image/')

		preview.innerHTML = `
			<div class="media-card-thumbnail ${isImage ? '' : 'media-card-thumbnail-placeholder'}">
				${isImage
			? `<img src="${item.path}" alt="${item.name}" class="media-card-thumbnail" />`
			: `<svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
						 <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m2.25 0H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z" />
					 </svg>`
	}
			</div>
			<div class="progress-ring-container">
				<svg class="progress-ring" width="48" height="48" viewBox="0 0 48 48">
					<circle class="progress-ring-bg" cx="24" cy="24" r="20" fill="none" stroke="rgba(255,255,255,0.2)" stroke-width="4"/>
					<circle class="progress-ring-circle stroke-primary" cx="24" cy="24" r="20" fill="none" stroke-width="4" stroke-dasharray="125.66" stroke-dashoffset="125.66" stroke-linecap="round"/>
				</svg>
				<span class="progress-ring-text">0%</span>
			</div>
			<div class="media-card-overlay">
				<span class="media-card-filename">${item.name}</span>
				<p class="status"></p>
			</div>
    `
    
    this.listTarget.appendChild(preview)
  }

  removeFile(e) {
    e.preventDefault()
    e.stopPropagation()
    const index = e.params.index

    this.items.splice(index, 1)
    const preview = this.listTarget.querySelector(`#upload-${index}`)

    if(preview)
      this.listTarget.removeChild(preview)

    const dataTransfer = new DataTransfer()
    this.items.forEach(item => dataTransfer.items.add(item.file))
    this.inputTarget.files = dataTransfer.files
  }

  #uploadFile(item) {
    const preview = this.listTarget.querySelector(`#upload-${item.index}`)
    const status = preview.querySelector('.status')
		const circle = preview.querySelector('.progress-ring-circle')
		const text = preview.querySelector('.progress-ring-text')

    const formData = new FormData()
    formData.append('file', item.file)

    const xhr = new XMLHttpRequest()
    xhr.open("POST", this.uploadUrlValue, true)
    xhr.setRequestHeader("X-CSRF-Token", document.querySelector("meta[name=csrf-token]").content)

    // ON PROGRESS
    xhr.upload.addEventListener('progress', (event) => {
      if (event.lengthComputable) {
				const percent = Math.round((event.loaded / event.total) * 100)
				const circumference = 2 * Math.PI * 20 // r=20
				circle.style.strokeDashoffset = circumference - (percent / 100) * circumference
				text.textContent = `${percent}%`
      }
    })

    // ON FINISH
    xhr.onload = () => {
      if(xhr.status !== 200) {
        status.textContent = "❌ Échec création Medium"
				circle.classList.add('hidden')
				text.classList.add('hidden')
      } else {
				Turbo.renderStreamMessage(xhr.responseText)
				preview.remove()
      }
    }

    xhr.onerror = () => {
      status.textContent = "❌ Erreur réseau"
    }

    xhr.send(formData)
  }

  submit(event) {
    this.items.forEach(item => {
      this.#uploadFile(item)
    })
  }
}
