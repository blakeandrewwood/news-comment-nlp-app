import API from "./api"

/**
 * Validates comment
 * @param {Object} comment
 */
export function validateComment(comment) {
  let error = null;
  if(comment.body.length < 1) {
    error = 'Comment must be at least 1 character';
  }
  if(comment.body.length > 1000) {
    error = 'Comment must be less than 1000 characters';
  }
  return error;
}

/**
 * Returns number of comments
 * @param {}
 */
export function getNumComments() {
  let text = $("#num_comments").text();
  return text.match(/\d+/)[0];
}

/**
 * Updates number of comments display
 * @param {number} amount
 */
export function updateNumComments(amount) {
  let text = $("#num_comments").text();
  let numCommentsString = text.replace(/^\d+/g, amount);
  $("#num_comments").text(numCommentsString);
}

/**
 * Increments number of comments display
 * @param {}
 */
export function incrementNumComments() {
  let numComments = getNumComments();
  numComments++;
  updateNumComments(numComments);
  $("#num_comments").addClass("pulse");
  setTimeout(() => $("#num_comments").removeClass("pulse"), 500);
}

/**
 * Decrements number of comments display
 * @param {}
 */
export function decrementNumComments() {
  let numComments = getNumComments();
  numComments--;
  updateNumComments(numComments);
  $("#num_comments").addClass("pulse");
  setTimeout(() => $("#num_comments").removeClass("pulse"), 1000);
}

/**
 * Adds comment to comment container
 * @param {string} html
 * @param {number} parentId
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
 * Removes comment from comment container
 * @param {number} id
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
 * Initializes all comments
 * @param {}
 */
export function initializeComments() {
  $('.comment').each(initializeComment);
}

/**
 * Initializes comment
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
    if(validateComment(data)) {
      return;
    }
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
  if($(this).data().userId == window.current_user_id) {
    $($(this).find('.comment-delete')).removeClass('hide');
    $($(this).find('.comment-delete')[0]).click(function (event) {
      event.preventDefault();
      let comment = $(this).parents('.comment')[0];
      let commentId = $(comment).data().id;
      API.Comments.del(commentId);
    });
  }

}

/**
 * Initializes comment form
 * @param {}
 */
export function initializeCommentForm() {
  $('#submit_comment_form').submit(function(event) {
    event.preventDefault();
    let body = $('#comment').val();
    let data = {
      body: body
    };
    if(validateComment(data)) {
      return;
    }
    $('#comment').val("");
    API.Comments.create(data);
  });
}