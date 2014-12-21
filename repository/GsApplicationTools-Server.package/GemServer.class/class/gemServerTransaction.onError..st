transactions
gemServerTransaction: aBlock onError: errorBlock
  System transactionMode == #'autoBegin'
    ifFalse: [ 
      System inTransaction
        ifTrue: [ self error: 'I should not be called when already in transaction' ] ].
  GRPlatform current transactionMutex
    critical: [ 
      | conflicts |
      self doBeginTransaction.
      aBlock
        on: self gemServerExceptionSet
        do: [ :ex | 
          ex isResumable
            ifTrue: [ 
              self logError: ex titled: 'application error'.
              ex resume ]
            ifFalse: [ 
              self doSimpleTransaction: [ self logError: ex titled: 'application error' ].
              errorBlock value: ex ] ].
      ^ self doCommitTransaction
        ifTrue: [ true ]
        ifFalse: [ 
          "failed commit ... log the conmmit conflict and fail the transaction"
          conflicts := System transactionConflicts.
          self doAbortTransaction.
          self
            doSimpleTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ].
          false ] ]