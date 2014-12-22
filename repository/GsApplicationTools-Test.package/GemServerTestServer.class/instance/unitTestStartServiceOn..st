service instance-script
unitTestStartServiceOn: portOrNil
  "called from development environment ... service run in current vm."

  self
    scriptLogEvent:
      '-->>Interactive Start ' , self name , ' on ' , portOrNil printString
    object: self.
  self
    transactionMode: #'autoBegin';
    interactiveMode: false.
  self startServiceOn: portOrNil	"does not return"