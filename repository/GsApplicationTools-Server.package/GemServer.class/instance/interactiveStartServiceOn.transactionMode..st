service instance-script
interactiveStartServiceOn: portOrResourceName transactionMode: mode
  "called from development environment ... service run in current vm."

  "transactionMode: #autoBegin or #manualBegin"

  self
    scriptLogEvent:
      '-->>Interactive Start ' , self name , ' on ' , portOrResourceName printString
    object: self.
  self transactionMode: mode.
  mode == #'manualBegin'
    ifTrue: [ self startTransactionBacklogHandling ].
  self
    enableAlmostOutOfMemoryHandling;
    startServerOn: portOrResourceName	"does not return"