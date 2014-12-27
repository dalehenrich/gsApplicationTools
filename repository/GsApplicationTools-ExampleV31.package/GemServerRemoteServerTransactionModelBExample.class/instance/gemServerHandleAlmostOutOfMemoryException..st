exception dispatching
gemServerHandleAlmostOutOfMemoryException: exception
  "for GemServerRemoteClientExample>>scheduleOutOfMemoryTemp, we treat like an error, when commit doesn't help.
   for GemServerRemoteClientExample>>scheduleOutOfMemoryPersistent, the commit should free up space and we'll resume"

  AlmostOutOfMemory enable.
  System inTransaction
    ifTrue: [ 
      self doCommitTransaction.
      System _vmMarkSweep.
      System _tempObjSpacePercentUsedLastMark < self almostOutOfMemoryThreshold
        ifTrue: [ 
          "dropped below the threshold, the commit gained some space, so continue processing."
          self doBeginTransaction.	"put us back in transaction before resuming"
          exception resume ] ].
  self gemServerHandleErrorException: exception	"out of transaction or commit did not free up enough memory, treat like error and unwind stack"