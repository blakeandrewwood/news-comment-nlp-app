import "phoenix_html"

import socket from "./socket"

import {
  initializeCommentForm,
  initializeComments
} from "./comments.js"

$(document).ready(function() {

  $('.carousel').carousel();

  initializeCommentForm();
  initializeComments();

});
