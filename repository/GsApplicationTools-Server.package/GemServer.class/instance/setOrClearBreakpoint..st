remote breakpoints
setOrClearBreakpoint: aSetOrClearBreakpointAnnouncement
  "need to bounce the server so that new GsProcess instances will signal the Breakpoint"

  self logDebug: 'Set or clear breakpoint'.
  self bounceServerForBreakpointHandling