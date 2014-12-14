breakpoint handling
bounceServerForBreakpointHandling
  "In GemStone 3.0, Breakpoints are only signalled from a portable (non-native) process.
   Override this method and pass in a block that restarts the necessary server threads (i.e.,
   those threads in which remote break points may be set."

  self
    bounceServerAfterSetOrClearBreakpoints: [ 
      self serverInstance
        ifNotNil: [ :server | 
          self log
            info:
              'Bounced server, because of set or clear breakpoints: '
                , self activeProcessIsNative printString.
          server stop.
          self startBasicServerOn: server port ] ]