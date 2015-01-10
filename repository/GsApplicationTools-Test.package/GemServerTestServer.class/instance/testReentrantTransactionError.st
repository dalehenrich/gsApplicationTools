actions
testReentrantTransactionError
  self
    gemServerTransaction: [ 
      actionResult := #'RESUMED????'.
      self logAction: #'testReentrantTransactionError' ]