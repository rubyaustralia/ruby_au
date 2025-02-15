import 'core-js/stable';
import 'regenerator-runtime/runtime';
import Rails from '@rails/ujs';
import $ from 'jquery';
import "trix";
import "@rails/actiontext";
import SignaturePad from "signature_pad";

// Expose jQuery globally
window.$ = $;
window.jQuery = $;

Rails.start();

// Import Styles
import "./styles/actiontext.css";
import "./styles/application.scss";
import "./styles/committee.scss";
import "./styles/sponsorship.scss";
import "./styles/forms.scss";
import "./styles/admin.scss";
import "./styles/signatures.scss";
import "./styles/surveys.scss";

/**
 * Initializes mobile menu toggle
 */
document.addEventListener('DOMContentLoaded', () => {
  const menuTrigger = document.querySelector('.mobile-menu-trigger');
  const mobileMenu = document.querySelector('.mobile-menu');
  
  menuTrigger?.addEventListener('click', () => {
    if (mobileMenu) {
      mobileMenu.classList.toggle('show');
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
  $(document).on('submit', '#set-proxy-form', function(event) {
    if ($("#rsvp_proxy_name").val().trim() === "") {
      alert("Please provide the name of your proxy representative.");
      return false;
    }
    if (signaturePad.isEmpty()) {
      alert("Please provide a signature.");
      return false;
    }
    $('#rsvp_proxy_signature').val(signaturePad.toDataURL());
  });
};
