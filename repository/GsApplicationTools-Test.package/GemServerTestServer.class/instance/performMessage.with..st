messages
performMessage: aSymbol with: anObject
  "sent on the client"

  self doAbortTransaction.
  messageCount := messageCount + 1.
  actionSymbol := aSymbol.
  messageObject := anObject.
  self doCommitTransaction