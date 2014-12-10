private
scriptLogEvent: label object: anObject
  GRPlatform current
    doTransaction: [ (ObjectLogEntry info: label object: anObject) addToLog ]