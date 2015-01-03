initialization
initialize
  super initialize.
  serverProcess := TransientValue value: nil.
  self initErrorLog