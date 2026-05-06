import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab", "panel"];
  static values = { default: Number };
  static classes = ["active"];

  connect() {
    this.show(this.defaultValue || 0);
  }

  select(event) {
    const index = event.currentTarget.dataset.index;
    this.show(index);
  }

  show(index) {
    this.panelTargets.forEach((el) => {
      el.hidden = el.dataset.index != index;
    });

    this.tabTargets.forEach((el) => {
      el.classList.toggle(this.activeClass, el.dataset.index == index);
      el.dataset.state = el.dataset.index == index ? "active" : "inactive";
    });
  }
}
