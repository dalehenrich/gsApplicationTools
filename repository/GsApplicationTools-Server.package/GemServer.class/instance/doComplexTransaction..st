transactions
doComplexTransaction: aBlock
  self transactionMutex
    critical: [ 
      | commitResult |
      [ 
      System inTransaction
        ifTrue: [ aBlock value ]
        ifFalse: [ 
          self doBeginTransaction.
          aBlock value ] ]
        ensure: [ 
          "workaround for Bug 42963: ensure: block executed twice (don't return from ensure: block)"
          commitResult := self doCommitTransaction
            ifTrue: [ true ]
            ifFalse: [ 
              | conflicts |
              "failed commit ... log the conmmit conflict and fail the transaction"
              conflicts := System transactionConflicts.
              self doAbortTransaction.
              self
                doSimpleTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ].
              false ] ].
      ^ commitResult ]