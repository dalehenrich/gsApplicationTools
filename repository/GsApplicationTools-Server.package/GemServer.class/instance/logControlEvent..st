private
logControlEvent: label
  self
    doSimpleTransaction: [ (ObjectLogEntry info: label object: self) addToLog ]