import "phoenix_html"

import socket from "./socket"

import {
  initializeLogin
} from "./login.js"

import {
  initializeRegister
} from "./register.js"

import {
  initializeCarousel
} from "./carousel.js"

import {
  initializeCommentForm,
  initializeComments
} from "./comments.js"

$(document).ready(function() {
  initializeLogin();
  initializeRegister();
  initializeCarousel();
  initializeCommentForm();
  initializeComments();
});
