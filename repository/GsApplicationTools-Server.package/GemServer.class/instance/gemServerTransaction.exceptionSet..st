gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet
  self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    onError: [ :ex | 
      "server error is already logged"
       ]