actions
processTask: gemServer
  self hasValue
    ifFalse: [ 
      | value |
      value := taskBlock cull: gemServer.
      self setValue: value gemServer: gemServer ]