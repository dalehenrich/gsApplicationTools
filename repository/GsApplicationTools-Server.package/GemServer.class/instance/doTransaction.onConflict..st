transactions-support
doTransaction: aBlock onConflict: conflictBlock
  "Perform a transaction. If the transaction fails, evaluate <conflictBlock> with transaction 
   conflicts dictionary."

  (self doBasicTransaction: aBlock)
    ifFalse: [ 
      | conflicts |
      conflicts := System transactionConflicts.
      self doAbortTransaction.
      conflictBlock value: conflicts ]