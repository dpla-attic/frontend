jQuery.waypoints.settings.scrollThrottle = 10

Backbone.on 'bookshelf:init', ->
  $content = $ '#content'
  $stickyWrapper = $ '.waypoint-wrapper'
  $footer = $ '.container > footer'

  $content.waypoint
    handler: (direction) ->
      $stickyWrapper.toggleClass 'stuck', direction is 'down'
    offset: -41

  $footer.waypoint
    handler: (direction) ->
      $stickyWrapper.toggleClass 'unstuck', direction is 'down'
      $stickyWrapper.toggleClass 'stuck', direction is 'up'
    offset: ->
      $.waypoints('viewportHeight') + 30

