transactions-support
doSimpleTransaction: aBlock
  "I do an unconditional commit. If running in manual transaction mode, the system will be outside 
   of transaction upon returning. "

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