import { leave, enter } from "../transistion";
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"];

  connect() {
    this.currentUrl = window.location.href;
  }

  sidebarTargetConnected(sidebar) {
    // Close on click outside a sidebar
    this.overlayTarget.addEventListener("click", async (event) => {
      if (event.target !== event.currentTarget) return;

      // close all
      for (let index = 0; index < this.sidebarTargets.length; index++) {
        const sidebar = this.sidebarTargets[index];
        await this.close(sidebar);
      }

      this.overlayTarget.classList.remove("hidden");
    });
  }

  toggle({ params: { id } }) {
    const sidebar = this.sidebarTargets.find((s) => s.getAttribute("id") == id);
    if (sidebar) {
      if (sidebar.classList.contains("hidden")) {
        this.open(sidebar);
      } else {
        this.close(sidebar);
      }
    }
  }

  open(sidebar) {
    this.overlayTarget.classList.remove("hidden");
    sidebar.classList.remove("hidden");
    enter(sidebar);
  }

  close(sidebar) {
    Promise.all([leave(sidebar)]).then(() => {
      // this.overlayTarget.classList.add("hidden")
      sidebar.classList.add("hidden");
      this.overlayTarget.classList.add("hidden");
      // enter(sidebar)
    });
  }
}
