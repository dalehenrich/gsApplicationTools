service instance-script
interactiveStartServiceOn: portOrNil transactionMode: mode
  "called from development environment ... service run in current vm."

  "transactionMode: #autoBegin or #manualBegin"

  self
    scriptLogEvent:
      '-->>Interactive Start ' , self name , ' on ' , portOrNil printString
    object: self.
  self doTransaction: [ self interactiveMode: true ].
  self transactionMode: mode.
  mode == #'manualBegin'
    ifTrue: [ self startSigAbortHandling ].
  self
    enableAlmostOutOfMemoryHandling;
    startServiceOn: portOrNil	"does not return"