import 'core-js/stable';
import 'regenerator-runtime/runtime';
import Rails from '@rails/ujs';
import "trix";
import "@rails/actiontext";
import SignaturePad from "signature_pad";

import './social-share-button';

Rails.start();

// Import Styles
import 'trix/dist/trix.css';

import "~/stylesheets/actiontext.css";
import "~/stylesheets/custom_actiontext.scss";
import "~/stylesheets/application.scss";
import "~/stylesheets/committee.scss";
import "~/stylesheets/sponsorship.scss";
import "~/stylesheets/forms.scss";
import "~/stylesheets/admin.scss";
import "~/stylesheets/signatures.scss";
import "~/stylesheets/surveys.scss";
import "~/stylesheets/social-share-button.css";

/**
 * Initializes mobile menu toggle
 */
document.addEventListener('DOMContentLoaded', () => {
  const menuTrigger = document.querySelector('.mobile-menu-trigger');
  const mobileMenu = document.querySelector('.mobile-menu');

  if (window.innerWidth < 768) {
    mobileMenu?.classList.add('hidden');
  }

  menuTrigger?.addEventListener('click', () => {
    if (mobileMenu) {
      mobileMenu.classList.toggle('hidden');
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

  /**
   * Resizes the canvas to match device pixel ratio for better rendering.
   */
  function resizeCanvas() {
    const ratio = Math.max(window.devicePixelRatio || 1, 1);

    canvas.width = canvas.offsetWidth * ratio;
    canvas.height = canvas.offsetHeight * ratio;
    canvas.getContext("2d").scale(ratio, ratio);

    signaturePad.clear();
  }

  // Resize canvas on window resize
  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();

  // Clear button event
  clearButton?.addEventListener("click", () => signaturePad.clear());

  // Undo last stroke event
  undoButton?.addEventListener("click", () => {
    const data = signaturePad.toData();
    if (data.length > 0) {
      data.pop();
      signaturePad.fromData(data);
    }
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
