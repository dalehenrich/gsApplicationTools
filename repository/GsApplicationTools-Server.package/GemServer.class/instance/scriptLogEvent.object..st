private
scriptLogEvent: label object: anObject
  "object log and transcript entries wanted"

  Transcript
    cr;
    show: 'scriptLogEvent: ' , label printString.
  self doTransaction: [ (ObjectLogEntry info: label object: anObject) addToLog ]