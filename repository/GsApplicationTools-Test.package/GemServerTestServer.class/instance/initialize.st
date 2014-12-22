initialization
initialize
  super initialize.
  maintenanceProcess := TransientValue value: nil.
  messageCount := 1.
  actionSymbol := #'serverStarted'.
  actionCount := 0.
  messageObject := actionResult := nil