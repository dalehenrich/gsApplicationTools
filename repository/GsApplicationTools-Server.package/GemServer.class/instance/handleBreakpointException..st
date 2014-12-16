breakpoint handling
handleBreakpointException: exception
  "Snap off continuation, then resume if possible"

  GRPlatform current
    doTransaction: [ DebuggerLogEntry createContinuationLabeled: exception description ].
  exception isResumable
    ifTrue: [ exception resume ]
    ifFalse: [ exception pass ]