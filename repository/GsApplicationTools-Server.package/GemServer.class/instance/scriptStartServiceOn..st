service instance-script
scriptStartServiceOn: portOrNil
  "called from shell script"

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
    startServiceOn: portOrNil	"does not return"