exception handling
logStack: exception titled: title inTransactionDo: inTransactionBlock
  super
    logStack: exception
    titled: title
    inTransactionDo: [ 
      errorLog add: (ObjectLogEntry error: title object: exception).
      inTransactionBlock value ]