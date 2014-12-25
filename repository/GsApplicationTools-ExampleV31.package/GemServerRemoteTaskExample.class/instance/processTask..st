actions
processTask: gemServer
  self hasValue
    ifFalse: [ 
      | value |
      value := taskBlock cull: gemServer.
      gemServer
        doSimpleTransaction: [ 
          taskValue := value.
          hasValue := true.
          valuation := DateAndTime now ] ]