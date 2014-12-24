tracing
trace: labelBlock object: objectBlock
  self tracing
    ifFalse: [ ^ self ].
  self
    doSimpleTransaction: [ (ObjectLogEntry trace: labelBlock value object: objectBlock value) addToLog ]