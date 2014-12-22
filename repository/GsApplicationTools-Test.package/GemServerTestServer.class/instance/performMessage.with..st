messages
performMessage: aSymbol with: anObject
  "sent on the client"

  messageCount := messageCount + 1.
  actionSymbol := aSymbol.
  messageObject := anObject.
  System commitTransaction