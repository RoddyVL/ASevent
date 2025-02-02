// app/javascript/controllers/chats_list_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
 static targets = ["chat", "chatContainer"]

  highlight(event) {
    this.chatTargets.forEach((chat) => {
      chat.classList.remove("active")
    });
    event.currentTarget.classList.add("active");
  }

  toggleChat() {
    if (this.hasChatContainerTarget) {
      const container = this.chatContainerTarget;
      const icon =
      container.classList.toggle("d-none");
    }
  }
}
