gem server api
gemServerTransaction: aBlock onConflict: conflictBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]
    ensure: [  ]
    onConflict: conflictBlock