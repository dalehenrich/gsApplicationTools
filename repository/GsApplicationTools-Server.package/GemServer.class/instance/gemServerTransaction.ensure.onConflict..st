gem server api
gemServerTransaction: aBlock ensure: ensureBlock onConflict: conflictBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]
    ensure: ensureBlock
    onConflict: conflictBlock