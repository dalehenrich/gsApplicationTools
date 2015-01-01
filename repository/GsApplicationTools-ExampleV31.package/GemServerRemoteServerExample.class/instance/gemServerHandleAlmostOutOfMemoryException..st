exception dispatching
gemServerHandleAlmostOutOfMemoryException: exception
  "unwind stack, when commit doesn't gain back temp space."

  | inTransaction |
  AlmostOutOfMemory enable.
  inTransaction := System inTransaction.
  inTransaction
    ifTrue: [ 
      inTransaction := true.
      self doCommitTransaction.
      System _vmMarkSweep.
      System _tempObjSpacePercentUsedLastMark < self almostOutOfMemoryThreshold
        ifTrue: [ 
          "dropped below the threshold, the commit gained some space, so continue processing."
          self doBeginTransaction.	"put us back in transaction before resuming"
          exception resume ] ].
  inTransaction
    ifTrue: [ 
      "Put back into transaction before unwinding the stack"
      self doBeginTransaction ].
  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '	"out of transaction or commit did not free up enough memory, unwind stack"