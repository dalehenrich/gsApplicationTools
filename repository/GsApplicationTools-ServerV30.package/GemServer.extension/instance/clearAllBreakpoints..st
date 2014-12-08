*gsapplicationtools-serverv30
clearAllBreakpoints: aClearBreakpointAnnouncement
  "need to bounce the server so that new GsProcess instances will be native"

  self logDebug: 'Clear all breakpoints'.
  self bounceServerForBreakpointHandling