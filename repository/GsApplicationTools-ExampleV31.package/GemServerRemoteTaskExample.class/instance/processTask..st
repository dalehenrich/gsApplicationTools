actions
processTask: gemServer
  self hasValue
    ifFalse: [ 
      | value |
      value := taskBlock value.
      gemServer
        doSimpleTask: [ 
          taskValue := value.
          hasValue := true ] ]