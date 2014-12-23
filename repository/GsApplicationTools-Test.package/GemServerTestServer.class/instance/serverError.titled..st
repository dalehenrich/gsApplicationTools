error handling
serverError: exception titled: title
  self
    serverError: exception
    titled: title
    inTransactionDo: [ 
      actionResult := #'internalServerError'.
      actionException := exception.
      self logAction: #'internalServerError:titled:' ]