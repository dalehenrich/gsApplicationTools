gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet ensure: ensureBlock
  ^ self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]
    ensure: ensureBlock