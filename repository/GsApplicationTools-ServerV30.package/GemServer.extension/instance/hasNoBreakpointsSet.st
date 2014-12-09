*gsapplicationtools-serverv30
hasNoBreakpointsSet
  | breakReport |
  breakReport := (GsNMethod _breakReport: false) at: 2.
  self logDebug: [ 'hasNoBreakpointsSet: ' , breakReport printString ].
  ^ breakReport isEmpty