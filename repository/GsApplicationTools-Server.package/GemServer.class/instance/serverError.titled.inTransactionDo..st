exception handling
serverError: exception titled: title inTransactionDo: inTransactionBlock
  self doInteractiveModePass: exception.
  self
    logStack: exception
    titled: title , ' Server error encountered:'
    inTransactionDo: inTransactionBlock