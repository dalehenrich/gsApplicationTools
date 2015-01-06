transactions-support
doTraceTransaction: aBlock
  | commitResult |
  commitResult := true.
  self transactionMutex
    critical: [ 
      System inTransaction
        ifTrue: [ 
          "in transaction ... don't interfere"
          aBlock value ]
        ifFalse: [ 
          [ 
          self doBeginTransaction.
          aBlock value ]
            ensure: [ 
              "workaround for Bug 42963: ensure: block executed twice (don't return from ensure: block)"
              commitResult := self doCommitTransaction ] ] ].
  ^ commitResult