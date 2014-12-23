transactions-support
doComplexTransaction: aBlock onConflict: conflictBlock
  "I do an unconditional commit. Caller is responsible for restoring proper commit state, if necessary"

  "do not do a non-local return from <conflictBlock> otherwise ensure block may be evaluated twice. 
   Bug 42963: ensure: block executed twice (don't return from ensure: block)"

  self transactionMutex
    critical: [ 
      [ 
      System inTransaction
        ifTrue: [ aBlock value ]
        ifFalse: [ 
          self doBeginTransaction.
          aBlock value ] ]
        ensure: [ 
          self doCommitTransaction
            ifFalse: [ conflictBlock value: System transactionConflicts ] ] ]