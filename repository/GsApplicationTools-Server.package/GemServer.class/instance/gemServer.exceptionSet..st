gem server api
gemServer: aBlock exceptionSet: exceptionSet
  self
    gemServer: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]