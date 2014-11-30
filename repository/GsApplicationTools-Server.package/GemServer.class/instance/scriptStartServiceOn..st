service instance-script
scriptStartServiceOn: port
  "called from shell script"

  self
    scriptLogEvent: 'Start ' , self name , ' on ' , port printString
    object: self.
  self
    recordGemPid: port;
    setStatmonCacheName;
    enableRemoteBreakpointHandling.
  System transactionMode: #'manualBegin'.
  self
    startSigAbortHandling;
    startServiceOn: port	"does not return"