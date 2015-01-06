initialization
initialize
  super initialize.
  enableRemoteBreakpoints := true.
  ports := self defaultPortList.
  serverInstance := TransientValue value: nil.
  interactiveMode := false.
  transactionMode := #'manualBegin'.
  enableCreateContinuations := true.
  basicServerProcess := TransientValue value: nil.
  self initCrashLog