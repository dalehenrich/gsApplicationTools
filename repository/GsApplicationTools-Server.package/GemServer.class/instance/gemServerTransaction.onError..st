transactions
gemServerTransaction: aBlock onError: errorBlock
  (System inTransaction and: [ self transactionMode ~~ #'autoBegin' ])
    ifTrue: [ 
      self
        error:
          'Expected to be outside of transaction. Try calling doAbortTransaction or doCommitTransaction before calling.' ].
  self transactionMutex
    critical: [ 
      self doBeginTransaction.
      aBlock
        on: self gemServerExceptionSet
        do: [ :ex | 
          ((ex isKindOf: Error) or: [ ex isResumable not ])
            ifTrue: [ 
              self
                doSimpleTransaction: [ 
                  self logError: ex titled: self name , ' error/non-resumable exception'.
                  errorBlock value: ex ].
              self interactiveMode
                ifTrue: [ ex pass ].
              ^ #'error' ]
            ifFalse: [ 
              self interactiveMode
                ifTrue: [ ex pass ].
              self logError: ex titled: self name , ' resumable exception'.
              ex resume ] ].
      ^ self doCommitTransaction
        ifTrue: [ true ]
        ifFalse: [ 
          | conflicts |
          "failed commit ... log the conmmit conflict and fail the transaction"
          conflicts := System transactionConflicts.
          self doAbortTransaction.
          self
            doSimpleTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ].
          false ] ]