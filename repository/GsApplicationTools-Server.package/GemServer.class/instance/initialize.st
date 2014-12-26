initialization
initialize
  super initialize.
  enableRemoteBreakpoints := true.
  ports := self defaultPortList.
  serverInstance := TransientValue value: nil.
  interactiveMode := false.
  transactionMode := #'manualBegin'.
  enableCreateContinuations := true.
  self initCrashLog