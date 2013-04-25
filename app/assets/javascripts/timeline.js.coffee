jQuery ->
  window.timeline = timeline = new DPLA.Models.Timeline
  new DPLA.Routers.TimelineRouter timeline: timeline
  new DPLA.Views.Timeline.Scrubber timeline: timeline
  Backbone.history.start pushState: false, root: '/timeline'