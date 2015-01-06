tracing
trace: labelBlock object: objectBlock
  self tracing
    ifFalse: [ ^ self ].
  self
    doTraceTransaction: [ (ObjectLogEntry trace: labelBlock value object: objectBlock value) addToLog ]