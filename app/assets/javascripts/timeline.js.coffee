jQuery ->
  window.timeline = timeline = new DPLA.Models.Timeline
  new DPLA.Routers.TimelineRouter timeline: timeline
  new DPLA.Views.TimelineScrubber timeline: timeline
  Backbone.history.start pushState: false, root: '/timeline'