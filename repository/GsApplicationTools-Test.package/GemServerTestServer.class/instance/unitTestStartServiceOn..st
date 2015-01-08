service instance-script
unitTestStartServiceOn: portOrResourceName
  "called from development environment ... service run in current vm."

  self
    scriptLogEvent:
      '-->>Interactive Start ' , self name , ' on ' , portOrResourceName printString
    object: self.
  self
    transactionMode: #'autoBegin';
    interactiveMode: false.
  self startServerOn: portOrResourceName	"does not return"