accessing
enableRemoteBreakpoints
  enableRemoteBreakpoints ifNil: [ enableRemoteBreakpoints := true ].
  ^ enableRemoteBreakpoints