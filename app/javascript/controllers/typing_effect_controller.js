import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text"];

  connect() {
    this.textTargets.forEach((target, index) => {
      // Ajouter un délai différent pour chaque élément
      setTimeout(() => this.typeText(target), index * 1000); // Délai de 1 seconde entre chaque élément
    });
  }

  typeText(target) {
    const text = target.innerHTML;
    target.innerHTML = "";
    let index = 0;
    const speed = 100; // Vitesse d'écriture (en ms)

    const type = () => {
      if (index < text.length) {
        target.innerHTML += text.charAt(index);
        index++;
        setTimeout(type, speed);
      }
    };

    type();
  }
}
