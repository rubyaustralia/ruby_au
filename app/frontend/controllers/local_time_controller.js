import { Controller } from "@hotwired/stimulus"

/**
* @example
*   <time datetime="<%= event.happens_at.iso8601 %>" data-controller="local-time" />
*/
export default class extends Controller {
  connect() {
    const iso = this.element.getAttribute("datetime");
    if (!iso) return;

    const date = new Date(iso);
    if (isNaN(date)) return;

    // this trickery allows us to keep the display format consistent
    // rather than rely on the browser locale format
    // which is better for testing
    // and is easier on the eyes
    const parts = new Intl.DateTimeFormat(undefined, {
      day: "2-digit",
      month: "short",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
      hour12: false,
      timeZoneName: "short",
    }).formatToParts(date);

    const get = (type) => parts.find((p) => p.type === type)?.value;

    this.element.textContent =
      `${get("day")} ${get("month")} ${get("year")}, ` +
      `${get("hour")}:${get("minute")} ${get("timeZoneName")}`;
  }
}
