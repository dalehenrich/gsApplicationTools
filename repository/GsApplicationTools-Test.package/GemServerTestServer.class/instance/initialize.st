initialization
initialize
  super initialize.
  serverProcess := TransientValue value: nil.
  messageCount := 1.
  actionSymbol := #'serverStarted'.
  actionCount := 0.
  messageObject := actionResult := nil