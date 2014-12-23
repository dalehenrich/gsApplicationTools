transactions-support
doSimpleTransaction: aBlock
  "I do an unconditional commit. Caller is responsible for restoring proper commit state"

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
          commitResult := self doCommitTransaction ].
      ^ commitResult ]