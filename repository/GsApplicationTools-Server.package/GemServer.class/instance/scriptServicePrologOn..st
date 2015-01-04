service instance-server
scriptServicePrologOn: portOrNil
  self
    scriptLogEvent:
      '-->>Script Start ' , self name , ' on ' , portOrNil printString
    object: self.
  self
    recordGemPid: portOrNil;
    setStatmonCacheName;
    enableRemoteBreakpointHandling.
  self transactionMode: #'manualBegin'.
  self
    startSigAbortHandling;
    enableAlmostOutOfMemoryHandling