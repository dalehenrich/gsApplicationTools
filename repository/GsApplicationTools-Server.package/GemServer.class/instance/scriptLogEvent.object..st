private
scriptLogEvent: label object: anObject
  Transcript
    cr;
    show: 'scriptLogEvent: ' , label printString.
  self
    doSimpleTransaction: [ (ObjectLogEntry info: label object: anObject) addToLog ]