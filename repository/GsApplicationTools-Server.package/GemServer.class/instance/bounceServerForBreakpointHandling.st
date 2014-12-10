server specialization
bounceServerForBreakpointHandling
  "In GemStone 3.0, Breakpoints are only signalled from a portable (non-native) process.
   Override this method and pass in a block that restarts the necessary server threads (i.e.,
   those threads in which remote break points may be set."

  self bounceServerAfterSetOrClearBreakpoints: [  ]