// app/frontend/controllers/hello_controller.js
// This is a Stimulus controller that updates the content of a target element
// when the controller is connected to the DOM.
// It demonstrates how to use Stimulus targets and the connect lifecycle method.
// This controller is automatically registered when using the `registerControllers` function.
//// To use this controller, add the `data-controller` attribute to a parent element
// and the `data-hello-target` attribute to the target element.
// For example:
// <div data-controller="hello">
//   <span data-hello-target="output"></span>
// </div>
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  connect() {
    console.log("Hello controller connected")
    if (this.hasOutputTarget) {
      this.outputTarget.textContent = "Hello from Stimulus!"
    }
  }
}
