private
logControlEvent: label
  self doTransaction: [ (ObjectLogEntry info: label object: self) addToLog ]