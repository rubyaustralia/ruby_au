import "@hotwired/turbo-rails";
import "~/controllers";
import 'core-js/stable';
import 'regenerator-runtime/runtime';
import Rails from '@rails/ujs';
import "trix";
import "@rails/actiontext";
import SignaturePad from "signature_pad";
import '~/icons';

Rails.start();

import "~/stylesheets/actiontext.css";
import "~/stylesheets/custom_actiontext.scss";
import "~/stylesheets/application.scss";
import "~/stylesheets/signatures.scss";

// Import the icons you need
import { createIcons, User, LogIn } from 'lucide';

// Initialize icons when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  createIcons({
    icons: {
      'circle-user': User,
      'log-in': LogIn,
      // Add other icons you need
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

  // Form submission validation
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
