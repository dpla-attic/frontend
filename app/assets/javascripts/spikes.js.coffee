jQuery ->
  $('form').on 'click', 'a.btn.orange', ->
    $(this).parents('form').submit()
    false