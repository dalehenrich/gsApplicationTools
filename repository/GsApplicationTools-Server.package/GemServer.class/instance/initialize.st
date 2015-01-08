initialization
initialize
  super initialize.
  enableRemoteBreakpoints := true.
  portOrResourceNameList := self defaultPortOrResourceNameList.
  serverInstance := TransientValue value: nil.
  interactiveMode := false.
  transactionMode := #'manualBegin'.
  enableCreateContinuations := true.
  basicServerProcess := TransientValue value: nil.
  self initCrashLog