private
logControlEvent: label
  | eventBlock |
  eventBlock := [ (ObjectLogEntry info: label object: self) addToLog ].
  System inTransaction
    ifTrue: [ eventBlock value ]
    ifFalse: [ self doTransaction: eventBlock ]