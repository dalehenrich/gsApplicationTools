transactions
gemServerTransaction: aBlock onError: errorBlock
  self transactionMode == #'autoBegin'
    ifFalse: [ 
      System inTransaction
        ifTrue: [ 
          "inTransaction and running in #manualBegin transaction mode ... should be outside of transaction"
          self
            error:
              'Expected to be outside of transaction. Try calling doAbortTransaction or doCommitTransaction before calling.' ] ].
  GRPlatform current transactionMutex
    critical: [ 
      | conflicts |
      self doBeginTransaction.
      aBlock
        on: self gemServerExceptionSet
        do: [ :ex | 
          ((ex isKindOf: Error) or: [ ex isResumable not ])
            ifTrue: [ 
              self
                doSimpleTransaction: [ 
                  self logError: ex titled: 'application error - non resumable'.
                  errorBlock value: ex ].
              ^ #'error' ]
            ifFalse: [ 
              self logError: ex titled: 'application error - resumable'.
              ex resume ] ].
      ^ self doCommitTransaction
        ifTrue: [ true ]
        ifFalse: [ 
          "failed commit ... log the conmmit conflict and fail the transaction"
          conflicts := System transactionConflicts.
          self doAbortTransaction.
          self
            doSimpleTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ].
          false ] ]