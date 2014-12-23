actions
processTask: gemServer
  self hasValue
    ifFalse: [ 
      | value |
      value := taskBlock value.
      gemServer
        doSimpleTransaction: [ 
          taskValue := value.
          hasValue := true ] ]