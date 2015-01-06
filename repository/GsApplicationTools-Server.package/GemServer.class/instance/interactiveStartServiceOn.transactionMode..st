service instance-script
interactiveStartServiceOn: portOrNil transactionMode: mode
  "called from development environment ... service run in current vm."

  "transactionMode: #autoBegin or #manualBegin"

  self
    scriptLogEvent:
      '-->>Interactive Start ' , self name , ' on ' , portOrNil printString
    object: self.
  self transactionMode: mode.
  mode == #'manualBegin'
    ifTrue: [ self startTransactionBacklogHandling ].
  self
    enableAlmostOutOfMemoryHandling;
    startServerOn: portOrNil	"does not return"