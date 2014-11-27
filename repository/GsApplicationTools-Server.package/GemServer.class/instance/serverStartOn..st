service instance-script
serverStartOn: port
  "called from shell script"

  portInstance := port.
  self
    recordGemPid;
    setStatmonCacheName;
    enableRemoteBreakpointHandling.
  System transactionMode: #'manualBegin'.
  self
    startSigAbortHandling;
    startService	"does not return"