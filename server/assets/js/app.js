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
 * Create comment
 * @param {Object} comment
 */
function submitComment(comment) {
  $.ajax({
    url: '/api/comments',
    dataType: 'json',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({ comment: comment }),
    processData: false,
    success: function(data) {
      Materialize.toast('Comment submitted.', 4000);
    },
    error: function(jqXhr, textStatus, errorThrown){
      Materialize.toast('Error: ' + errorThrown, 4000);
    }
  });
}

/**
 * Delete comment
 * @param {string} commentId
 */
function deleteComment(commentId) {
  $.ajax({
    url: '/api/comments/' + commentId,
    dataType: 'json',
    type: 'DELETE',
    contentType: 'application/json',
    data: JSON.stringify({ id: commentId }),
    processData: false,
    success: function(data) {
      Materialize.toast('Comment deleted.', 4000);
    },
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
      body: body
    };
    $('#comment').val("");
    submitComment(data);
  });

  $('.comment').each(function() {
    let timestamp = $(this).data().timestamp;
    let date = new Date(timestamp);
    let timeFromNow = moment(date).fromNow();
    let commentTimestamp= $(this).find('.comment__timestamp')[0];
    $(commentTimestamp).text(timeFromNow);
  });

  $('.comment__reply').submit(function(event) {
    event.preventDefault();
    let comment = $(this).parents('.comment')[0];
    let commentBody = $(comment).find("textarea[name='comment_body']")[0];
    let commentId = $(comment).find("input[name='comment_id']")[0];
    let data = {
      body: $(commentBody).val(),
      comment_id: $(commentId).val()
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

  $('.comment-delete').click(function (event) {
    event.preventDefault();
    let comment = $(this).parents('.comment')[0];
    let commentId = $(comment).data().id;
    deleteComment(commentId);
  });

});
