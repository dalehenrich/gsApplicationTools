service instance-private
startSigAbortHandling
  self scriptLogEvent: 'startSigAbortHandling: ' , self name object: self.
  Exception
    installStaticException: [ :ex :cat :num :args | 
      "Run the abort in a lowPriority process, since we must acquire the
       transactionMutex."
      [ 
      GRPlatform current transactionMutex
        critical: [ GRPlatform current doAbortTransaction ].
      System enableSignaledAbortError ]
        forkAt: Processor lowestPriority ]
    category: GemStoneError
    number: 6009
    subtype: nil.
  System enableSignaledAbortError.	"This thread is needed to handle the SigAbort exception, when the primary
 thread is blocked on an accept. Assuming default 60 second 
 STN_GEM_ABORT_TIMEOUT, wake up at 30 second intervals."
  [ [ true ] whileTrue: [ (Delay forSeconds: 30) wait ] ]
    forkAt: Processor lowestPriority