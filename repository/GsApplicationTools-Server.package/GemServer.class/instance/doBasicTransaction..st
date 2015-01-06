transactions-support
doBasicTransaction: aBlock
  "I do an unconditional commit. 
   If running in manual transaction mode, the system will be outside of transaction upon 
    returning.
   Return true, if the transaction completed without conflicts.
   If the transaction fails, return false and the caller is responsible for post commit failure
   processing."

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