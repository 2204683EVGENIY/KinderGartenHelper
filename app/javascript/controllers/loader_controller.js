import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loader"
export default class extends Controller {
  static targets = ["button", "spinner"]

  show() {
    this.buttonTarget.classList.add("d-none")
    this.spinnerTarget.classList.remove("d-none")
  }
}
