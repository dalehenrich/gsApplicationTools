gem server api
gemServer: aBlock exceptionSet: exceptionSet ensure: ensureBlock
  ^ self
    gemServer: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]
    ensure: ensureBlock