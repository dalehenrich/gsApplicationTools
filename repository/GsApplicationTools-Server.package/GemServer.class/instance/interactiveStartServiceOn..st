service instance-script
interactiveStartServiceOn: portOrNil
  "called from development environment ... service run in current vm."

  self
    scriptLogEvent:
      '-->>Interactive Start ' , self name , ' on ' , portOrNil printString
    object: self.
  self transactionMode: #'autoBegin'.
  self startServiceOn: portOrNil	"does not return"