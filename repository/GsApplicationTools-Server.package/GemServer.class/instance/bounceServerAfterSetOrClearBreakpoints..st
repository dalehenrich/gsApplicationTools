remote breakpoints
bounceServerAfterSetOrClearBreakpoints: restartServerBlock
  "In GemStone 3.0, Breakpoints are only signalled from a portable (non-native) process.
   This method bounces the necessary server processes using <restartServerBlock>."

  self hasNoBreakpointsSet
    ifTrue: [ 
      "fork restartServerBlock in native process"
      self
        logInfo:
          'No breakpoints: fork native thread: ' , self activeProcessIsNative printString.
      GemServerLauncher forkNative: restartServerBlock ]
    ifFalse: [ 
      "fork restartServerBlock in portable process"
      self
        logInfo:
          'Breakpoints: fork portable thread: ' , self activeProcessIsNative printString.
      GemServerLauncher forkPortable: restartServerBlock ]