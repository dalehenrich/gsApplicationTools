private
scriptLogEvent: label object: anObject
  "object log and transcript entries wanted"

  Transcript
    cr;
    show: 'scriptLogEvent: ' , label printString.
  self
    doSimpleTransaction: [ (ObjectLogEntry info: label object: anObject) addToLog ]