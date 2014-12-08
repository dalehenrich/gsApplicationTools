*gsapplicationtools-serverv30
hasNoBreakpointsSet
  self
    logDebug: [ 'hasNoBreakpointsSet: ' , ((GsNMethod _breakReport: false) at: 2) printString ].
  ^ ((GsNMethod _breakReport: false) at: 2) isEmpty