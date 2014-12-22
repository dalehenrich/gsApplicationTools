transactions
doTransaction: aBlock
  "No commit if we are already inTransaction."

  | commitResult |
  System inTransaction
    ifTrue: [ 
      "We already are in a transaction, so just evaluate the block"
      aBlock value.
      ^ true ]
    ifFalse: [ 
      [ 
      self doBeginTransaction.
      aBlock value ]
        ensure: [ 
          "workaround for Bug 42963: ensure: block executed twice (don't return from ensure: block)"
          commitResult := self doCommitTransaction ] ].
  ^ commitResult