initialization
initialize
  super initialize.
  enableRemoteBreakpoints := true.
  ports := self defaultPortList.
  serverInstance := TransientValue value: nil