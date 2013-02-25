jQuery ->
  $('#loginBox form#sign_in').on 'ajax:success', (e, data) ->
    if data.success
      alert 'success'
    else
      alert 'not'
#   $('#loginBox').on 'click', 'input', (event) ->
#     if $(this).attr('value') == 'Log In'
#       alert "Login"
#     if $(this).attr('value') == 'Submit'
#       alert "Forgive password"
#     false