actions
performReentrantTransactionError
  self
    gemServerTransaction: [ 
      actionResult := #'RESUMED????'.
      self logAction: #'performReentrantTransactionError' ]