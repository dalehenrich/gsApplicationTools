private
logControlEvent: label
  GRPlatform current
    doTransaction: [ (ObjectLogEntry info: label object: self) addToLog ]