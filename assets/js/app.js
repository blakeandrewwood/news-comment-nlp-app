import "phoenix_html"

import socket from "./socket"

import {
  initializeCommentForm,
  initializeComments
} from "./comments.js"

$(document).ready(function() {

  // Misc features
  $('.carousel').carousel();

  // Comments
  initializeCommentForm();
  initializeComments();

});
