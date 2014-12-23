gem server api
gemServer: aBlock exceptionSet: exceptionSet
  self
    gemServer: aBlock
    exceptionSet: exceptionSet
    onError: [ :ex | 
      "server error is already logged"
       ]