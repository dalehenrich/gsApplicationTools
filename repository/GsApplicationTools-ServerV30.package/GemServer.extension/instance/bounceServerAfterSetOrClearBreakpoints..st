*gsapplicationtools-serverv30
bounceServerAfterSetOrClearBreakpoints: restartServerBlock
  "In GemStone 3.0, Breakpoints are only signalled from a portable (non-native) process.
   This method bounces the necessary server processes using <restartServerBlock>."

  | sema activeProcess convertToPortable |
  self hasNoBreakpointsSet
    ifTrue: [ 
      "should be native"
      GsProcess usingNativeCode
        ifTrue: [ 
          "no need to bounce server threads"
          ^ self ].
      convertToPortable := false ]
    ifFalse: [ 
      "should be portable"
      convertToPortable := true ].
  activeProcess := ProcessorScheduler scheduler activeProcess.
  sema := Semaphore new.
  [ 
  activeProcess localStackDepth.	"convert process to OM"
  convertToPortable
    ifTrue: [ activeProcess _convertToPortableStack ]
    ifFalse: [ 
      activeProcess _nativeStack
        ifFalse: [ 
          "no _convertToNativeStack implementation available"
           ] ].
  sema signal ]
    fork.
  sema wait.
  restartServerBlock value