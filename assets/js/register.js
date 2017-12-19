export function initializeRegister() {
  $('#register-form').submit(function(event) {

    let username = $('#register-input-username');
    let password = $('#register-input-password');
    let confirmPassword = $('#register-input-confirm-password');

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

    if(!password.val() || password.val() != confirmPassword.val()) {
      event.preventDefault();
      confirmPassword.addClass('invalid');
    } else {
      confirmPassword.removeClass('invalid');
    }

  });
}