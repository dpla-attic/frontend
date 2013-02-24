jQuery ->
  $('form').on 'click', 'a.btn', ->
    $(this).parents('form').submit()
    false