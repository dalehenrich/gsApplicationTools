gem server api
gemServerTransaction: aBlock onError: errorBlock onConflict: conflictBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    onError: errorBlock
    onConflict: conflictBlock