transactions-support
doTransaction: aBlock
  "Perform a transaction. If the transaction fails, signal an Error."

  self
    doTransaction: aBlock
    onConflict: [ :conflicts | 
      (self
        doBasicTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ])
        ifTrue: [ self error: 'commit conflicts' ]
        ifFalse: [ 
          self doAbortTransaction.
          self error: 'commit conflicts - could not log conflict dictionary' ] ]