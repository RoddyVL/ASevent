// app/javascript/controllers/chats_list_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
 static targets = ["chat"]

  highlight(event) {
    this.chatTargets.forEach((chat) => {
      chat.classList.remove("active")
    });
    event.currentTarget.classList.add("active");
  }
}
