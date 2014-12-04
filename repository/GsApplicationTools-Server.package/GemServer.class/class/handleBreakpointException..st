breakpoint handling
handleBreakpointException: exception
  "Handle breakpoint or halt, snap off continuation, then resume"

  Transcript
    cr;
    show: 'Creating continuation for: ' , exception description printString.
  GRPlatform current
    doTransaction: [ DebuggerLogEntry createContinuationLabeled: exception description ].
  exception isResumable
    ifTrue: [ exception resume ]
    ifFalse: [ exception pass ]