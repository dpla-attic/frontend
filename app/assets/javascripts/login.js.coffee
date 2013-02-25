jQuery ->
  $('#loginBox form#sign_in').bind 'ajax:success', (e, data) ->
    if data.success == true
      window.location.href = data.redirect
    else
      window.location.href = 'users/sign_in'
    false

  $('#loginBox form#password_new').bind 'ajax:success', (e, data) ->
    if data.success == true
      window.location.href = data.redirect
    else
      window.location.href = 'users/password/new'
    false

  $('#signupBox form#sign_up').bind 'ajax:success', (e, data) ->
    if data.success == true
      window.location.href = data.redirect
    else
      window.location.href = 'users/password/new'
    false