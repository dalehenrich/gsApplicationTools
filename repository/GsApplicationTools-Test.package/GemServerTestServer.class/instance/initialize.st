initialization
initialize
  super initialize.
  messageCount := 1.
  actionSymbol := #'serverStarted'.
  actionCount := 0.
  messageObject := actionResult := nil.
  forceBeginTransaction := forceInternalServerError := false