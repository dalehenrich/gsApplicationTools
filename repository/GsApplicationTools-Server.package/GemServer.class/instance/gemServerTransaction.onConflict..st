gem server api
gemServerTransaction: aBlock onConflict: conflictBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    onError: [ :ex | 
      "server error is already logged"
       ]
    onConflict: conflictBlock