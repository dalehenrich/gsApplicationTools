private
scriptLogEvent: label object: anObject
  "object log"

  | eventBlock |
  Transcript
    cr;
    show: 'scriptLogEvent: ' , label printString.
  eventBlock := [ (ObjectLogEntry info: label object: anObject) addToLog ].
  System inTransaction
    ifTrue: [ eventBlock value ]
    ifFalse: [ self doTransaction: eventBlock ]