service instance-private
enableRemoteBreakpointHandling
  "Enable remote Breakpoing handling"

  self enableRemoteBreakpoints
    ifFalse: [ ^ self ].
  Breakpoint trappable: true.
  GemToGemAnnouncement installStaticHandler.
  System commitTransaction
    ifFalse: [ self error: 'Could not commit for GemToGemSignaling' ]