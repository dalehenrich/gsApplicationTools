*gsapplicationtools-serverv24
hasNoBreakpointsSet
  | breakReport |
  breakReport := (GsMethod _breakReport: false) at: 2.
  self logDebug: [ 'hasNoBreakpointsSet: ' , breakReport printString ].
  ^ breakReport isEmpty