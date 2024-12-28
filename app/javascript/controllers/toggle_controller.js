import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
 static targets = [ "toggableElement" ]

 fire() {
  this.toggableElementTarget.classList.toggle("d-none");
 }
}
