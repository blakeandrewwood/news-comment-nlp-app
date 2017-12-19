export function initializeLogin() {
  $('#login-form').submit(function(event) {

    let username = $('#login-input-username');
    let password = $('#login-input-password');

    if(!username.val() || username.val().length < 3 ) {
      event.preventDefault();
      username.addClass('invalid');
    } else {
      username.removeClass('invalid');
    }

    if(!password.val()) {
      event.preventDefault();
      password.addClass('invalid');
    } else {
      password.removeClass('invalid');
    }

  });
}