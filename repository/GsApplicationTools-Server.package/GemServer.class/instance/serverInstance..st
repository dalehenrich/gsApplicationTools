accessing
serverInstance: aServer
  serverInstance
    ifNil: [ serverInstance := TransientValue value: aServer ]
    ifNotNil: [ serverInstance value: aServer ]