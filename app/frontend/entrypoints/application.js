import 'core-js/stable'
import 'regenerator-runtime/runtime'
import Rails from '@rails/ujs';
import $ from 'jquery';
window.$ = $;
window.jQuery = $;

Rails.start();

import "trix";
import SignaturePad from "signature_pad";

import "./styles/actiontext.css";
import "./styles/application.scss";
import "./styles/committee.scss";
import "./styles/sponsorship.scss";
import "./styles/forms.scss";
import "./styles/admin.scss";
import "./styles/signatures.scss";
import "./styles/surveys.scss";

$(document).ready(() => {
  $('#mobile-menu-trigger').on('click', () => $('#mobile-menu').slideToggle());
});

window.setupSignature = function() {
  var wrapper = document.getElementById("signature-pad");
  var clearButton = wrapper.querySelector("[data-action=clear]");
  var undoButton = wrapper.querySelector("[data-action=undo]");
  var canvas = wrapper.querySelector("canvas");
  var signaturePad = new SignaturePad(canvas, {
    backgroundColor: 'rgb(255, 255, 255)'
  });

  // Adjust canvas coordinate space taking into account pixel ratio,
  // to make it look crisp on mobile devices.
  // This also causes canvas to be cleared.
  function resizeCanvas() {
    // When zoomed out to less than 100%, for some very strange reason,
    // some browsers report devicePixelRatio as less than 1
    // and only part of the canvas is cleared then.
    var ratio =  Math.max(window.devicePixelRatio || 1, 1);

    // This part causes the canvas to be cleared
    canvas.width = canvas.offsetWidth * ratio;
    canvas.height = canvas.offsetHeight * ratio;
    canvas.getContext("2d").scale(ratio, ratio);

    // This library does not listen for canvas changes, so after the canvas is automatically
    // cleared by the browser, SignaturePad#isEmpty might still return false, even though the
    // canvas looks empty, because the internal data of this library wasn't cleared. To make sure
    // that the state of this library is consistent with visual state of the canvas, you
    // have to clear it manually.
    signaturePad.clear();
  }

  // On mobile devices it might make more sense to listen to orientation change,
  // rather than window resize events.
  window.onresize = resizeCanvas;
  resizeCanvas();

  clearButton.addEventListener("click", function (event) {
    signaturePad.clear();
  });

  undoButton.addEventListener("click", function (event) {
    var data = signaturePad.toData();

    if (data) {
      data.pop(); // remove the last dot or line
      signaturePad.fromData(data);
    }
  });

  $('#set-proxy-form').on('submit', function(event) {
    if ($("#rsvp_proxy_name").val().length == 0) {
      alert("Please provide the name of your proxy representative.");
      return false;
    }
    if (signaturePad.isEmpty()) {
      alert("Please provide a signature.");
      return false;
    }

    $('#rsvp_proxy_signature').val(signaturePad.toDataURL());
  });
}
