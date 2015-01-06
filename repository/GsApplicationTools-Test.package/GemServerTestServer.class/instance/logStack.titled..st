error handling
logStack: exception titled: title
  self
    logStack: exception
    titled: title
    inTransactionDo: [ 
      actionResult := #'internalServerError'.
      actionException := exception.
      self logAction: #'internalServerError:titled:' ]