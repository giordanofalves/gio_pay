import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  load_chart(event) {
    const frame = document.getElementById('chart_data');
    frame.src = event.target.value;
  }
}
