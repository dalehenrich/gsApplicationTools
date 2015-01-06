exception handling
saveContinuationFor: exception titled: title inTransactionDo: inTransactionBlock
  | label |
  label := title , ': ' , exception description.
  System inTransaction
    ifTrue: [ 
      self createContinuation: label.
      inTransactionBlock value ]
    ifFalse: [ 
      self
        doTransaction: [ 
          self createContinuation: label.
          inTransactionBlock value ] ]