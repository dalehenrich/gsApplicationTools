private
interactiveErrorCommit: aBlock
  [ 
  System inTransaction
    ifTrue: [ aBlock value ]
    ifFalse: [ 
      System beginTransaction.
      aBlock value ] ]
    ensure: [ System commitTransaction ]