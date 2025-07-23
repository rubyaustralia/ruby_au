import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["item"];

  setAriaCurrent(event) {
    this.itemTargets.forEach((element) => element.removeAttribute("aria-current"))
    event.currentTarget.setAttribute("aria-current", "page")
    
    // Update timeline to reflect selected event
    const eventId = event.currentTarget.id;
    const timelineController = this.application.getControllerForElementAndIdentifier(
      document.querySelector('[data-controller~="timeline"]'), 
      "timeline"
    );
    if (timelineController) {
      timelineController.selectedEventIdValue = eventId;
      
      // Scroll timeline to selected event with smooth animation
      setTimeout(() => {
        timelineController.scrollTimelineToSelectedEvent(true); // true = smooth scrolling
      }, 50);
    }
  }
}
