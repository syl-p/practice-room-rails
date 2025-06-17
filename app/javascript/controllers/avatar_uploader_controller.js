import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar-uploader"
export default class extends Controller {
  static targets = [ "input", "avatar", "removedField", "initials", "resetBtn" ]

  connect() {
  }

  change() {
    console.log("hello change")
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
    console.log("update avatar", this.inputTarget.files);
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
