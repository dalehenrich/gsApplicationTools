*gsapplicationtools-serverv30
enableRemoteBreakpointHandling
  "Enable remote Breakpoing handling"

  self enableRemoteBreakpoints
    ifFalse: [ ^ self ].
  Transcript
    cr;
    show: 'Enable remote breakpoint handling'.
  Breakpoint trappable: true.
  GemToGemAnnouncement installStaticHandler.
  System commitTransaction
    ifFalse: [ self error: 'Could not commit for GemToGemSignaling' ]