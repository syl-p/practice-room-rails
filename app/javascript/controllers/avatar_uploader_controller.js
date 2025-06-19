import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "avatar", "removedField", "initials", "resetBtn" ]

  connect() {
  }

  change() {
    this.#updateAvatar()
  }

  reset (e) {
    e.preventDefault()
    this.inputTarget.value = "";
    this.removedFieldTarget.value = "1";
    this.initialsTarget.classList.remove("hidden");
    this.resetBtnTarget.classList.add("hidden");
  }

  #updateAvatar() {
    if(this.inputTarget.files.length > 0) {
      const reader = new FileReader()
      reader.readAsDataURL(this.inputTarget.files[0])

      reader.onload = () => {
        console.log(reader.result)
        this.avatarTarget.src = reader.result
        this.initialsTarget.classList.add("hidden");
        this.resetBtnTarget.classList.remove("hidden");
      }
    }
  }
}
