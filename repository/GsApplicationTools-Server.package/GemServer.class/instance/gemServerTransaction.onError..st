transactions
gemServerTransaction: aBlock onError: errorBlock
  (System inTransaction and: [ self transactionMode ~~ #'autoBegin' ])
    ifTrue: [ 
      self
        error:
          'Expected to be outside of transaction. Use doAbortTransaction or doCommitTransaction before calling.' ].
  self doComplexTransaction: [ ^ self gemServer: aBlock onError: errorBlock ]