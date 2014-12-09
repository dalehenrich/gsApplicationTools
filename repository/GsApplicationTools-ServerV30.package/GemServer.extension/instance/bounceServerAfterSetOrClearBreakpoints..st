*gsapplicationtools-serverv30
bounceServerAfterSetOrClearBreakpoints: restartServerBlock
  "In GemStone 3.0, Breakpoints are only signalled from a portable (non-native) process.
   This method bounces the necessary server processes using <restartServerBlock>."

  self hasNoBreakpointsSet
    ifTrue: [ 
      "fork restartServerBlock in native process"
      self
        logInfo:
          'No breakpoints: fork native thread: '
            , GsProcess _current _nativeStack printString.
      GemServerLauncher forkNative: restartServerBlock ]
    ifFalse: [ 
      "fork restartServerBlock in portable process"
      self
        logInfo:
          'Breakpoints: fork portable thread: '
            , GsProcess _current _nativeStack printString.
      GemServerLauncher forkPortable: restartServerBlock ]