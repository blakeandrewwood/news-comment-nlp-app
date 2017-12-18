// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

/**
 * Submits comment to api
 * @param {Object} params
 * @param {Object} params.comment
 * @param {string} params.comment.body
 */
function submitComment(params) {
  Materialize.toast('Comment submitted.', 4000);
  $.ajax({
    url: '/api/comments',
    dataType: 'json',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(params),
    processData: false,
    error: function( jqXhr, textStatus, errorThrown ){
      Materialize.toast('Error: ' + errorThrown, 4000);
    }
  });
}

/**
 * Toggles comment reply
 * @param {Object} comment
 */
function toggleCommentReply(comment) {
  let commentReply = $(comment).find('.comment__reply')[0];
  if($(commentReply).hasClass('hide')) {
    $(this).text("Close");
    $(commentReply).removeClass('hide');
  }
  else {
    $(this).text("Reply");
    $(commentReply).addClass('hide')
  }
}

/* Initialize  */
$(document).ready(function() {

  $('.carousel').carousel();

  $('#submit_comment_form').submit(function(event) {
    event.preventDefault();
    let body = $('#comment').val();
    let data = {
      comment: {
        body: body
      }
    };
    submitComment(data);
  });

  $('.comment').each(function() {
    let commentTimestamp= $(this).find('.comment__timestamp')[0];
    let timestamp = $(commentTimestamp).data().timestamp;
    let date = new Date(timestamp);
    let timeFromNow = moment(date).fromNow();
    $(commentTimestamp).text(timeFromNow);
  });

  $('.comment__reply').submit(function(event) {
    event.preventDefault();
    let comment = $(this).parents('.comment')[0];
    let commentBody = $(comment).find("textarea[name='comment_body']")[0];
    let commentId = $(comment).find("input[name='comment_id']")[0];
    let data = {
      comment: {
        body: $(commentBody).val(),
        comment_id: $(commentId).val()
      }
    };
    $(commentBody).val("");
    toggleCommentReply(comment);
    submitComment(data);
  });

  $('.comment-reply').click(function (event) {
    event.preventDefault();
    let comment = $(this).parents('.comment')[0];
    toggleCommentReply(comment);
  });


});
