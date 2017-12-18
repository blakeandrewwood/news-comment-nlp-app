import API from "./api"

/**
 * TODO
 * @param {}
 */
export function getNumComments() {
  let text = $("#num_comments").text();
  return text.match(/\d+/)[0];
}

/**
 * TODO
 * @param {}
 */
export function updateNumComments(amount) {
  let text = $("#num_comments").text();
  let numCommentsString = text.replace(/^\d+/g, amount);
  $("#num_comments").text(numCommentsString);
}

/**
 * TODO
 * @param {}
 */
export function incrementNumComments(amount) {
  let numComments = getNumComments();
  numComments++;
  updateNumComments(numComments);
  $("#num_comments").addClass("pulse");
  setTimeout(() => $("#num_comments").removeClass("pulse"), 500);
}

/**
 * TODO
 * @param {}
 */
export function decrementNumComments(amount) {
  let numComments = getNumComments();
  numComments--;
  updateNumComments(numComments);
  $("#num_comments").addClass("pulse");
  setTimeout(() => $("#num_comments").removeClass("pulse"), 500);
}

/**
 * TODO
 * @param {}
 */
export function addComment(html, parentId) {
  incrementNumComments();
  let parent = $(".comments");
  if(parentId) {
    parent = $($(`.comment[data-id='${parentId}']`).find('.comment__replies')[0]);
  }
  let comment = parent.prepend(html).children()[0];
  initializeComment.call(comment);
}

/**
 * TODO
 * @param {}
 */
export function removeComment(id) {
  decrementNumComments();
  $(`.comment[data-id='${id}']`).remove();
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

/**
 * TODO
 * @param {}
 */
export function initializeComments() {
  $('.comment').each(initializeComment);
}

/**
 * TODO
 * @param {}
 */
export function initializeComment() {

  // Timestamp
  let timestamp = $(this).data().timestamp;
  let date = new Date(timestamp);
  let timeFromNow = moment(date).fromNow();
  let commentTimestamp= $(this).find('.comment__timestamp')[0];
  $(commentTimestamp).text(timeFromNow);

  // Reply form
  $($(this).find('.comment__reply')[0]).submit(function(event) {
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
    API.Comments.create(data);
  });

  // Reply action
  $($(this).find('.comment-reply')[0]).click(function (event) {
    event.preventDefault();
    let comment = $(this).parents('.comment')[0];
    toggleCommentReply(comment);
  });

  // Delete action
  $($(this).find('.comment-delete')[0]).click(function (event) {
    event.preventDefault();
    let comment = $(this).parents('.comment')[0];
    let commentId = $(comment).data().id;
    API.Comments.del(commentId);
  });

}

/**
 * TODO
 * @param {}
 */
export function initializeCommentForm() {
  $('#submit_comment_form').submit(function(event) {
    event.preventDefault();
    let body = $('#comment').val();
    let data = {
      body: body
    };
    $('#comment').val("");
    API.Comments.create(data);
  });
}



