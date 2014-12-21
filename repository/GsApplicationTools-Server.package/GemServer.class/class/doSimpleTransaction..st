transactions
doSimpleTransaction: aBlock
  "I do an unconditional commit. Caller is responsible for restoring proper commit state"

  [ 
  System inTransaction
    ifTrue: [ aBlock value ]
    ifFalse: [ 
      self doBeginTransaction.
      aBlock value ] ]
    ensure: [ ^ self doCommitTransaction ]