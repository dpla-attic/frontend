jQuery ->
  window.timeline = timeline = new DPLA.Models.Timeline
  new DPLA.Routers.TimelineRouter timeline: timeline
  new DPLA.Views.Timeline.Scrubber timeline: timeline
  Backbone.history.start pushState: false, root: '/timeline'

  $('.module.yellow .slidingDiv a, .refine a, .pop-columns a').click ->
    if ($('.timeContainer.yearsView').length > 0)
      window.location.href = $(this).attr('href') + window.location.hash
      false
