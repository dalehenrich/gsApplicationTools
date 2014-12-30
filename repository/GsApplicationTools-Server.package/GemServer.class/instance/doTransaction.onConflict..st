transactions-support
doTransaction: aBlock onConflict: conflictBlock
  "Perform a transaction. If the transaction fails, evaluate <conflictBlock> with transaction 
   conflicts dictionary."

  (self doBasicTransaction: aBlock)
    ifFalse: [ 
      self doAbortTransaction.
      conflictBlock value: System transactionConflicts ]