error handling
internalServerError: exception titled: title
  self internalServerError: exception titled: title shouldCommit: true.
  self
    doSimpleTransaction: [ 
      actionResult := #'internalServerError'.
      actionException := exception.
      self logAction: #'internalServerError:titled:' ]