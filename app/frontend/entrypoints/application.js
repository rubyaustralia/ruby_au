import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import { registerControllers } from "stimulus-vite-helpers";
import "~/controllers";
import 'core-js/stable';
import 'regenerator-runtime/runtime';
import Rails from '@rails/ujs';
import "trix";
import "@rails/actiontext";
import SignaturePad from "signature_pad";

const application = Application.start();
const controllers = import.meta.glob("../controllers/**/*_controller.js", { eager: true });
registerControllers(application, controllers);

Rails.start();

import "~/stylesheets/actiontext.css";
import "~/stylesheets/custom_actiontext.scss";
import "~/stylesheets/application.scss";
import "~/stylesheets/signatures.scss";

import { createIcons, icons } from 'lucide';

document.addEventListener('DOMContentLoaded', () => {
  createIcons({
    icons: icons,
    attrs: {
      class: "",
      stroke: "currentColor"
    }
  });
});

document.addEventListener('turbo:load', () => {
  createIcons({
    icons: icons,
    attrs: {
      class: "",
      stroke: "currentColor"
    }
  });
});

document.addEventListener('turbo:frame-load', () => {
  createIcons({
    icons: icons,
    attrs: {
      class: "",
      stroke: "currentColor"
    }
  });
});

/**
 * Initializes the signature pad and related interactions.
 */
window.setupSignature = function() {
  const wrapper = document.getElementById("signature-pad");
  if (!wrapper) return;

  const clearButton = wrapper.querySelector("[data-action=clear]");
  const undoButton = wrapper.querySelector("[data-action=undo]");
  const canvas = wrapper.querySelector("canvas");

  if (!canvas) return;

  const signaturePad = new SignaturePad(canvas, {
    backgroundColor: 'rgb(255, 255, 255)'
  });

  clearButton?.addEventListener("click", () => {
    signaturePad.clear();
  });

  undoButton?.addEventListener("click", () => {
    const data = signaturePad.toData();
    if (data) {
      data.pop(); // remove the last dot or line
      signaturePad.fromData(data);
    }
  });

  document.getElementById('set-proxy-form')?.addEventListener('submit', function(event) {
    const proxyName = document.getElementById('rsvp_proxy_name');
    const proxySignature = document.getElementById('rsvp_proxy_signature');

    if (proxyName?.value.trim() === "") {
      alert("Please provide the name of your proxy representative.");
      event.preventDefault();
      return;
    }
    if (signaturePad.isEmpty()) {
      alert("Please provide a signature.");
      event.preventDefault();
      return;
    }

    proxySignature.value = signaturePad.toDataURL();
  });
};

document.addEventListener('turbo:load', () => {
  window.setupSignature();
});
