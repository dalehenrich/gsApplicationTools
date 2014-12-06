*gsapplicationtools-serverv30
setOrClearBreakpoint: aSetOrClearBreakpointAnnouncement
  "need to bounce the server so that new GsProcess instances will signal the Breakpoint"

  self bounceServerForBreakpointHandling