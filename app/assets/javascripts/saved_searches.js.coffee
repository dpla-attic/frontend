$(document).ready ->
   $('.count').each (i) ->
      $.ajax
         url: $('.api_url')[i].value
         dataType: 'jsonp'
         cache: true
         success: (data)->
            $('.count')[i].textContent = data.count