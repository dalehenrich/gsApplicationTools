private
scriptLogEvent: label object: anObject
  self
    doSimpleTransaction: [ (ObjectLogEntry info: label object: anObject) addToLog ]