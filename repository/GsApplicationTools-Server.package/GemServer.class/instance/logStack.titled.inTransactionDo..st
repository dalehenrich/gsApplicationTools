exception handling
logStack: exception titled: title inTransactionDo: inTransactionBlock
  self
    saveContinuationFor: exception
    titled: title
    inTransactionDo: inTransactionBlock.
  self writeGemLogEntryFor: exception titled: title