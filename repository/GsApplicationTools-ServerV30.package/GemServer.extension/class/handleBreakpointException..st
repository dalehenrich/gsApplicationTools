*gsapplicationtools-serverv30
handleBreakpointException: exception
  "Handle breakpoint or halt, snap off continuation, then resume"

  GRPlatform current
    doTransaction: [ DebuggerLogEntry createContinuationLabeled: exception description ].
  exception isResumable
    ifTrue: [ exception resume ]
    ifFalse: [ exception pass ]