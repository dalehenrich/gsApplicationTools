gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet
  self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]